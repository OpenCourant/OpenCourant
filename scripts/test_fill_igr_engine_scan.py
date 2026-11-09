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

"""Regression checks for the engine-file scan in fill_igr.F (issue #67)."""

from pathlib import Path
import re
import unittest


FILL_IGR = Path(__file__).resolve().parents[1] / "starter/source/model/sets/fill_igr.F"
LOOP = re.compile(r"^\s*DO I = 1, 10000\s*$", re.MULTILINE)
EARLY_EXIT = re.compile(
    r"ELSE IF \(I > 2\) THEN.*?^\s*EXIT\s*$",
    re.MULTILINE | re.DOTALL,
)


class FillIgrEngineScanTests(unittest.TestCase):
    def test_both_scans_stop_after_the_first_gap_past_0001(self):
        source = FILL_IGR.read_text(encoding="utf-8")
        starts = [match.end() for match in LOOP.finditer(source)]
        self.assertEqual(
            len(starts),
            2,
            "fill_igr.F should scan engine files in two 0000-9999 loops "
            "(count, then fill)",
        )
        for index, start in enumerate(starts, start=1):
            end = starts[index] if index < len(starts) else len(source)
            body = source[start:end]
            with self.subTest(loop=index):
                self.assertRegex(
                    body,
                    EARLY_EXIT,
                    "loop %s must EXIT after a missing name past _0001.rad "
                    "instead of probing the rest of 0000-9999" % index,
                )


if __name__ == "__main__":
    unittest.main()
