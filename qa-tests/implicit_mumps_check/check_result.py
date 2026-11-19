# Copyright>        OpenCourant
# Copyright>        Copyright (C) 2026 OpenCourant contributors
# Copyright>
# Copyright>        This program is free software: you can redistribute it and/or modify
# Copyright>        it under the terms of the GNU Affero General Public License as published by
# Copyright>        the Free Software Foundation, either version 3 of the License, or
# Copyright>        (at your option) any later version.
# Copyright>
# Copyright>        This program is distributed in the hope that it will be useful,
# Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
# Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Copyright>        GNU Affero General Public License for more details.
# Copyright>
# Copyright>        You should have received a copy of the GNU Affero General Public License
# Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
# Copyright>
# Copyright>
# Copyright>        This file is part of OpenCourant, a fork of OpenRadioss.
# Copyright>        See COPYRIGHT.md at the root of the repository for the full
# Copyright>        copyright and attribution statement.
"""Check the result of the implicit MUMPS check case written by make_deck.py.

Reads, in the run folder:
  * mumps_check_0001.out  -- must say the linear solver was DIRECT(MUMPS) and end normally;
  * the last mumps_check_*.sty file (written by /OUTP) -- nodal displacements.

Compares with the exact uniform-stress answer of the bar (see make_deck.py):
  u_x at x = 100           = F L / (E A)          =  4.761905e-3 mm   (all 9 end nodes)
  u_y at y = 10 (any x)    = -nu * F / (E A) * 10 = -1.428571e-4 mm
  u_z at z = 10 (any x)    = the same as u_y
Tolerance 0.1 %: 8-node bricks represent uniform stress exactly, so any larger difference
is an error in the solve, not discretisation.
Usage: python check_result.py [run folder]     exit 0 = pass, 1 = fail
"""
import glob
import os
import sys

E, NU, FORCE, LX, AREA, WIDTH = 210000.0, 0.3, 1000.0, 100.0, 100.0, 10.0
TOL_PCT = 0.1


def read_sty_vectors(path):
    """Return {block name: {node id: (x, y, z)}} for the /NODAL/VECTOR blocks of a .sty file."""
    blocks, name = {}, None
    with open(path, encoding="latin-1") as fh:
        for line in fh:
            if line.startswith("/"):
                name = line.split("/")[3].strip() if line.startswith("/NODAL") else None
                if name:
                    blocks[name] = {}
                continue
            if name is None or line.startswith("#") or not line.strip():
                continue
            try:
                nid = int(line[:10])
                vals = tuple(float(line[10 + 20 * k:30 + 20 * k]) for k in range(3))
            except ValueError:
                continue          # the block's title line
            blocks[name][nid] = vals
    return blocks


def main():
    run = sys.argv[1] if len(sys.argv) > 1 else "."
    ok = True
    listing = os.path.join(run, "mumps_check_0001.out")
    text = open(listing, encoding="latin-1").read() if os.path.exists(listing) else ""
    mumps = "DIRECT(MUMPS)" in text
    normal = "NORMAL TERMINATION" in text
    print(f"Engine listing: linear solver MUMPS: {'yes' if mumps else 'NO'}; "
          f"normal termination: {'yes' if normal else 'NO'}")
    ok &= mumps and normal

    stys = sorted(glob.glob(os.path.join(run, "mumps_check_*.sty")))
    if not stys:
        print("FAIL: no .sty output file (the /OUTP request did not write)")
        return 1
    blocks = read_sty_vectors(stys[-1])
    coord = blocks.get("COORDINATE", {})
    disp = next((v for k, v in blocks.items() if k.startswith("DISPLACEM")), {})
    if not coord or not disp:
        print(f"FAIL: {os.path.basename(stys[-1])} has no coordinate or displacement block")
        return 1

    stress = FORCE / AREA
    checks = []    # (what, computed values, exact value)
    # Coordinates in the .sty are the deformed ones; positions are told apart by rounding.
    ref = {n: tuple(round(c - d, 3) for c, d in zip(coord[n], disp[n])) for n in disp}
    tip = [disp[n][0] for n, p in ref.items() if abs(p[0] - LX) < 1e-3]
    side_y = [disp[n][1] for n, p in ref.items() if abs(p[1] - WIDTH) < 1e-3]
    side_z = [disp[n][2] for n, p in ref.items() if abs(p[2] - WIDTH) < 1e-3]
    checks.append(("u_x at the loaded end (x = 100)", tip, stress * LX / E))
    checks.append(("u_y on the face y = 10", side_y, -NU * stress / E * WIDTH))
    checks.append(("u_z on the face z = 10", side_z, -NU * stress / E * WIDTH))

    print(f"Displacements from {os.path.basename(stys[-1])} (mm):")
    print(f"  {'quantity':34s} {'nodes':>5s} {'OpenCourant min':>16s} {'max':>14s} "
          f"{'exact':>14s} {'worst diff':>10s}")
    for what, vals, exact in checks:
        if not vals:
            print(f"  {what:34s}  no nodes found: FAIL")
            ok = False
            continue
        worst = max(abs(v - exact) / abs(exact) * 100.0 for v in vals)
        good = worst <= TOL_PCT
        ok &= good
        print(f"  {what:34s} {len(vals):5d} {min(vals):16.7e} {max(vals):14.7e} {exact:14.7e} "
              f"{worst:9.4f}% {'PASS' if good else 'FAIL'}")
    print("RESULT:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
