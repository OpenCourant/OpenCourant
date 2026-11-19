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
"""Write a small implicit linear static check deck for an OpenCourant build with MUMPS.

The model is a steel bar 100 x 10 x 10 mm (Mg, mm, s; N, MPa) meshed with 10 x 2 x 2
fully integrated bricks (/PROP/TYPE14, Isolid=14). The end x = 0 is held only in X, the
face y = 0 only in Y and the face z = 0 only in Z, so the bar stretches without any
restraint on its lateral contraction. A 1000 N pull in X is spread over the end x = 100 with
the consistent nodal shares of a uniform stress (corner 1/16, edge 1/8, centre 1/4).

Exact answer (uniform stress, which 8-node bricks represent exactly):
    stress    = F / A          = 1000 / 100              = 10 MPa
    u_x(x=L)  = F L / (E A)    = 1000 * 100 / (210000 * 100) = 4.761905e-3 mm
    u_y(y=10) = -nu * stress / E * 10                      = -1.428571e-4 mm (same for z)

The Engine file asks for one implicit linear step with solver 2 (direct solver, MUMPS when
the Engine was built with it) and writes nodal displacements to the ASCII output file.
Usage: python make_deck.py [output folder]   (default: this folder)
"""
import os
import sys

E, NU, RHO = 210000.0, 0.3, 7.85e-9
NX, NY, NZ = 10, 2, 2
LX, LY, LZ = 100.0, 10.0, 10.0
FORCE = 1000.0


def i10(*vals):
    return "".join(f"{v:10d}" for v in vals)


def f20(*vals):
    return "".join(f"{v:20.12E}" for v in vals)


def nid(i, j, k):
    return 1 + i * (NY + 1) * (NZ + 1) + j * (NZ + 1) + k


def grnod(lines, gid, title, nodes):
    nodes = sorted(nodes)
    lines += [f"/GRNOD/NODE/{gid}", title]
    for s in range(0, len(nodes), 10):
        lines.append(i10(*nodes[s:s + 10]))


def starter_lines():
    out = ["#RADIOSS STARTER", "/BEGIN", "mumps_check", i10(2024, 0),
           f"{'Mg':>20}{'mm':>20}{'s':>20}", f"{'Mg':>20}{'mm':>20}{'s':>20}", "/NODE"]
    for i in range(NX + 1):
        for j in range(NY + 1):
            for k in range(NZ + 1):
                out.append(f"{nid(i, j, k):10d}" + f20(LX * i / NX, LY * j / NY, LZ * k / NZ))
    out += ["/PART/1", "bar", i10(1, 1), "/MAT/LAW1/1", "steel", f20(RHO), f20(E, NU),
            "/PROP/TYPE14/1", "solid fully integrated", i10(14, 0, 0, 0, 0, 0, 0, 0), "", "",
            "/BRICK/1"]
    eid = 1
    for i in range(NX):
        for j in range(NY):
            for k in range(NZ):
                out.append(i10(eid, nid(i, j, k), nid(i + 1, j, k), nid(i + 1, j + 1, k),
                               nid(i, j + 1, k), nid(i, j, k + 1), nid(i + 1, j, k + 1),
                               nid(i + 1, j + 1, k + 1), nid(i, j + 1, k + 1)))
                eid += 1
    # Supports: one code per node, nodes grouped by code.
    codes = {}
    for i in range(NX + 1):
        for j in range(NY + 1):
            for k in range(NZ + 1):
                c = ("1" if i == 0 else "0") + ("1" if j == 0 else "0") + ("1" if k == 0 else "0")
                if c != "000":
                    codes.setdefault(c, []).append(nid(i, j, k))
    gid = 1
    for c, nodes in sorted(codes.items()):
        grnod(out, gid, f"held {c}", nodes)
        out += [f"/BCS/{gid}", f"symmetry {c}", f"   {c} 000" + i10(0, gid)]
        gid += 1
    # Tip load: consistent shares of a uniform traction on the 2 x 2 element end face.
    share = {}
    for j in range(NY + 1):
        for k in range(NZ + 1):
            wj = 0.5 if j in (0, NY) else 1.0
            wk = 0.5 if k in (0, NZ) else 1.0
            share.setdefault(wj * wk, []).append(nid(NX, j, k))
    out += ["/FUNCT/1", "constant 1", f20(0.0, 1.0), f20(1.0, 1.0)]
    for w, nodes in sorted(share.items()):
        fnode = FORCE * w / (NY * NZ)
        grnod(out, gid, f"tip share {w}", nodes)
        # funct, dir, skew, sensor, grnod; columns 51-60 blank; Ascale_x (61-80), Fscale_y (81-100)
        out += [f"/CLOAD/{gid}", f"tip pull {fnode} N per node",
                i10(1) + f"{'X':>10}" + i10(0, 0, gid) + " " * 10 + f20(1.0, fnode)]
        gid += 1
    out.append("/END")
    return out


ENGINE = """#RADIOSS ENGINE
/RUN/mumps_check/1
                 1.0
/IMPL/LINEAR
/IMPL/SOLVER/2
0 0 0 0.0
/IMPL/DTINI
                 1.0
/OUTP/DT
                 0.0                 1.0
/OUTP/VECT/DISP
/END
"""


def main():
    folder = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.abspath(__file__))
    os.makedirs(folder, exist_ok=True)
    with open(os.path.join(folder, "mumps_check_0000.rad"), "w", encoding="ascii", newline="\n") as fh:
        fh.write("\n".join(starter_lines()) + "\n")
    with open(os.path.join(folder, "mumps_check_0001.rad"), "w", encoding="ascii", newline="\n") as fh:
        fh.write(ENGINE)
    print(f"Wrote mumps_check_0000.rad and mumps_check_0001.rad in {folder}")


if __name__ == "__main__":
    main()
