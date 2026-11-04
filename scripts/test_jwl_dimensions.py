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

"""Static regression checks for JWL configuration unit metadata."""

from pathlib import Path
import re
import unittest


CFG_ROOT = Path(__file__).resolve().parents[1] / "hm_cfg_files/config/CFG"
UNREACTED_BULK_MODULUS = re.compile(
    r"^\s*SCALAR\s*\(\s*BUNREACTED\s*\)\s*(?:;|\{([^}]*)\})",
    re.MULTILINE,
)


class JwlDimensionTests(unittest.TestCase):
    def test_unreacted_bulk_modulus_has_pressure_dimension(self):
        configs = sorted(CFG_ROOT.glob("radioss*/MAT/matl5_jwl.cfg"))
        self.assertTrue(configs, "No JWL configurations found")
        declarations = 0

        for config in configs:
            content = config.read_text(encoding="utf-8")
            for match in UNREACTED_BULK_MODULUS.finditer(content):
                declarations += 1
                with self.subTest(config=config.relative_to(CFG_ROOT)):
                    self.assertRegex(
                        match.group(1) or "",
                        r'\bDIMENSION\s*=\s*"pressure"\s*;',
                        "BUNREACTED must convert as pressure between material "
                        "and model unit systems",
                    )

        self.assertGreater(declarations, 0, "No BUNREACTED declarations found")


if __name__ == "__main__":
    unittest.main()
