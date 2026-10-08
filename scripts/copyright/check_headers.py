#!/usr/bin/env python3
"""Check and fix OpenCourant copyright headers.

OpenCourant is the community continuation of OpenRadioss.  Every source
file carries exactly one of three header variants (see COPYRIGHT.md):

  legacy    Siemens (upstream) notice + OpenCourant pointer.
            Only valid for files that are unchanged from the
            `openradioss-final` tag.  Never generated anew.

  modified  Siemens notice + "Modified by the OpenCourant project"
            block + pointer.  Required for upstream files that have
            been changed relative to `openradioss-final`.

  new       OpenCourant notice + pointer (no Siemens block).  Required
            for files that have no upstream ancestor.

Usage:
  check_headers.py --all                    validate every tracked file
  check_headers.py --changed BASE           validate files changed vs BASE
  check_headers.py [--all|--changed BASE|paths...] --fix
                                            repair what can be repaired

Exits non-zero if problems are found (and not fixed).
"""

import argparse
import datetime
import os
import re
import subprocess
import sys

UPSTREAM_TAG = "openradioss-final"
ENCODING = "latin1"
PAD = "        "  # 8 spaces between the Copyright> marker and the text

# Extensions that MUST carry a header (enforced for changed files).
REQUIRED_EXT = {".F", ".F90", ".fy", ".inc", ".c", ".h",
                ".cpp", ".cxx", ".cu", ".hpp"}

# New files get a comment prefix based on extension.
PREFIX_BY_EXT = {
    ".F": "Copyright>", ".inc": "Copyright>",
    ".F90": "!Copyright>", ".fy": "!Copyright>",
    ".c": "//Copyright>", ".h": "//Copyright>", ".cpp": "//Copyright>",
    ".cxx": "//Copyright>", ".cu": "//Copyright>", ".hpp": "//Copyright>",
    ".py": "# Copyright>", ".pl": "# Copyright>",
}

# Paths never examined: foreign licenses (CFG, test decks) and the
# header template reference files.
EXCLUDED = re.compile(r"^(hm_cfg_files/|scripts/copyright/)|\.(cfg|rad)$")

HEADER_LINE_RE = re.compile(r"^([^A-Za-z0-9]*Copyright>)(.*)$")
YEARS_RE = r"(20\d\d(?:-20\d\d)?)"

SIEMENS = [
    "OpenRadioss",
    "Copyright (C) 2026 Siemens",
    "",
]
AGPL_CORE = [
    "This program is free software: you can redistribute it and/or modify",
    "it under the terms of the GNU Affero General Public License as published by",
    "the Free Software Foundation, either version 3 of the License, or",
    "(at your option) any later version.",
    "",
    "This program is distributed in the hope that it will be useful,",
    "but WITHOUT ANY WARRANTY; without even the implied warranty of",
    "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the",
    "GNU Affero General Public License for more details.",
    "",
    "You should have received a copy of the GNU Affero General Public License",
    "along with this program.  If not, see <https://www.gnu.org/licenses/>.",
]
SIEMENS_BLOCK = SIEMENS + AGPL_CORE  # 15 lines


def oc_block(years):
    return [
        "OpenCourant",
        "Copyright (C) %s OpenCourant contributors" % years,
        "",
        "Modified by the OpenCourant project, %s." % years,
        "Modifications are licensed under the GNU Affero General Public",
        "License, version 3 or (at your option) any later version.",
    ]


POINTER = [
    "This file is part of OpenCourant, a fork of OpenRadioss.",
    "See COPYRIGHT.md at the root of the repository for the full",
    "copyright and attribution statement.",
]


def legacy_header():
    return SIEMENS_BLOCK + ["", ""] + POINTER  # 20 lines


def modified_header(years):
    return SIEMENS_BLOCK + ["", ""] + oc_block(years) + [""] + POINTER  # 27


def new_header(years):
    return (["OpenCourant",
             "Copyright (C) %s OpenCourant contributors" % years,
             ""] + AGPL_CORE + ["", ""] + POINTER)  # 20 lines


# --------------------------------------------------------------------------
# git helpers
# --------------------------------------------------------------------------

def git(*args):
    return subprocess.run(["git"] + list(args), capture_output=True,
                          text=True, check=True).stdout


def git_blob(ref, path):
    """Return blob bytes at ref:path, or None if it does not exist."""
    res = subprocess.run(["git", "cat-file", "blob", "%s:%s" % (ref, path)],
                         capture_output=True)
    return res.stdout if res.returncode == 0 else None


def tag_file_set():
    try:
        out = git("ls-tree", "-r", "--name-only", UPSTREAM_TAG)
    except subprocess.CalledProcessError:
        return None
    return set(out.splitlines())


def strip_copyright(data):
    """Return content lines of a byte blob minus all Copyright> lines."""
    text = data.decode(ENCODING)
    return [l for l in text.splitlines() if not HEADER_LINE_RE.match(l)]


# --------------------------------------------------------------------------
# header parsing and validation
# --------------------------------------------------------------------------

class Header:
    def __init__(self, start, lines, prefix, content):
        self.start = start        # index of first header line
        self.lines = lines        # raw header lines (no line endings)
        self.prefix = prefix      # e.g. "!Copyright>"
        self.content = content    # text after prefix+padding, rstripped


def parse_header(raw_lines):
    """Find a contiguous Copyright> header at the top of the file.

    The header must start on the first line that is not a shebang or
    blank, within the first 5 lines.  Returns a Header or None.
    """
    for start in range(min(5, len(raw_lines))):
        line = raw_lines[start]
        if start == 0 and line.startswith("#!"):
            continue
        if not line.strip():
            continue
        m = HEADER_LINE_RE.match(line)
        if not m:
            return None
        prefix = m.group(1)
        lines, content = [], []
        for line in raw_lines[start:]:
            m = HEADER_LINE_RE.match(line)
            if not m or m.group(1) != prefix:
                break
            lines.append(line)
            rest = m.group(2).rstrip()
            if rest and not rest.startswith(PAD):
                return None  # malformed padding
            content.append(rest[len(PAD):] if rest else "")
        return Header(start, lines, prefix, content)
    return None


def match_years(pattern_line, actual):
    """Match a canonical line with YEARS placeholders; return years or None."""
    regex = "^" + re.escape(pattern_line).replace("YEARS", YEARS_RE) + "$"
    m = re.match(regex, actual)
    return m


def classify(content):
    """Classify header content lines.

    Returns (variant, years, error) where variant is one of
    'legacy', 'modified', 'new', or None with an error message.
    """
    def mismatch(idx, expected):
        got = content[idx] if idx < len(content) else "<missing>"
        return (None, None,
                "header line %d: expected %r, got %r" % (idx + 1, expected, got))

    if not content:
        return None, None, "empty header"

    if content[0] == "OpenRadioss":
        for i, exp in enumerate(SIEMENS_BLOCK):
            if i >= len(content) or content[i] != exp:
                return mismatch(i, exp)
        if len(content) > 15 and content[15] == "" and len(content) > 16 \
                and content[16] == "":
            body = content[17:]
        else:
            return mismatch(15, "(two blank separator lines)")
        if body[:1] == ["OpenCourant"]:
            # modified variant
            if len(body) != 10:
                return (None, None,
                        "modified block has %d lines, expected 10" % len(body))
            m1 = match_years("Copyright (C) YEARS OpenCourant contributors",
                             body[1])
            m2 = match_years("Modified by the OpenCourant project, YEARS.",
                             body[3])
            if not m1 or not m2 or m1.group(1) != m2.group(1):
                return (None, None,
                        "OpenCourant block year lines invalid or inconsistent")
            if (body[2] != "" or
                    body[4] != "Modifications are licensed under the GNU Affero General Public" or
                    body[5] != "License, version 3 or (at your option) any later version." or
                    body[6] != "" or body[7:] != POINTER):
                return None, None, "OpenCourant block text does not match canon"
            return "modified", m1.group(1), None
        if body == POINTER:
            return "legacy", None, None
        return (None, None,
                "unrecognized text after Siemens block: %r..." % body[:1])

    if content[0] == "OpenCourant":
        if len(content) != 20:
            return (None, None,
                    "new-file header has %d lines, expected 20" % len(content))
        m1 = match_years("Copyright (C) YEARS OpenCourant contributors",
                         content[1])
        if not m1:
            return None, None, "new-file copyright line invalid"
        if (content[2] != "" or content[3:15] != AGPL_CORE or
                content[15] != "" or content[16] != "" or
                content[17:] != POINTER):
            return None, None, "new-file header text does not match canon"
        return "new", m1.group(1), None

    if content[0].startswith('CFG Files and Library'):
        return "cfg", None, None  # foreign license, not ours to validate

    return None, None, "unrecognized header first line: %r" % content[0]


def years_include_current(years, current):
    end = years.split("-")[-1]
    return int(end) == current


def extend_years(years, current):
    start = int(years.split("-")[0])
    if start == current:
        return str(current)
    return "%d-%d" % (start, current)


# --------------------------------------------------------------------------
# per-file checking / fixing
# --------------------------------------------------------------------------

class FileReport:
    def __init__(self, path):
        self.path = path
        self.errors = []
        self.target = None       # desired (variant, years) when known

    def error(self, msg, target=None):
        self.errors.append(msg)
        if target:
            self.target = target


def read_raw(path):
    """Split strictly on '\\n' (str.splitlines would also split on
    form feeds, NEL, etc., corrupting files that contain such bytes).
    Elements keep any trailing '\\r'; joining with '\\n' is lossless.
    """
    with open(path, encoding=ENCODING, newline="") as fh:
        data = fh.read()
    lines = data.split("\n")
    crlf = bool(lines and lines[0].endswith("\r"))
    return lines, crlf


def content_differs(ref, path):
    """Does worktree content differ from ref:path, ignoring Copyright> lines?"""
    blob = git_blob(ref, path)
    if blob is None:
        return True
    with open(path, "rb") as fh:
        work = fh.read()
    return strip_copyright(work) != strip_copyright(blob)


def check_file(path, tag_files, current_year, require_current_year=False):
    """Validate one file.  Returns a FileReport (empty errors == OK)."""
    rep = FileReport(path)
    raw, _ = read_raw(path)
    header = parse_header(raw)
    in_tag = tag_files is None or path in tag_files

    if header is None:
        # Upstream shipped a handful of sources without headers; those
        # stay headerless.  Only genuinely new files must gain a header.
        ext = os.path.splitext(path)[1]
        if ext in REQUIRED_EXT and tag_files is not None \
                and path not in tag_files:
            rep.error("missing header (new file)", ("new", str(current_year)))
        return rep

    variant, years, err = classify(header.content)
    if err:
        # Structure is broken; pick the right target from git facts.
        if tag_files is not None and path not in tag_files:
            rep.error(err, ("new", str(current_year)))
        elif content_differs(UPSTREAM_TAG, path):
            rep.error(err, ("modified", str(current_year)))
        else:
            rep.error(err, ("legacy", None))
        return rep
    if variant == "cfg":
        return rep

    # git-consistency checks
    if tag_files is not None:
        if variant == "new" and in_tag:
            rep.error("has new-file header but exists in %s" % UPSTREAM_TAG,
                      ("modified", years or str(current_year)))
        elif variant in ("legacy", "modified") and not in_tag:
            rep.error("has upstream header but is absent from %s"
                      % UPSTREAM_TAG, ("new", years or str(current_year)))
        elif variant == "legacy" and content_differs(UPSTREAM_TAG, path):
            rep.error("content differs from %s but header lacks the "
                      "OpenCourant modification notice" % UPSTREAM_TAG,
                      ("modified", str(current_year)))

    if require_current_year and years is not None and not rep.errors:
        if not years_include_current(years, current_year):
            rep.error("modification years %r do not include %d"
                      % (years, current_year),
                      (variant, extend_years(years, current_year)))

    return rep


def render(variant, years, prefix, crlf):
    content = {"legacy": lambda: legacy_header(),
               "modified": lambda: modified_header(years),
               "new": lambda: new_header(years)}[variant]()
    cr = "\r" if crlf else ""
    return [(prefix + PAD + text if text else prefix) + cr
            for text in content]


def fix_file(path, rep, current_year, tag_files):
    variant, years = rep.target or (None, None)
    if variant is None:
        return False
    raw, crlf = read_raw(path)
    header = parse_header(raw)
    if header is not None:
        prefix = header.prefix
        start = header.start
        rest = raw[start + len(header.lines):]
    else:
        ext = os.path.splitext(path)[1]
        prefix = PREFIX_BY_EXT.get(ext)
        if prefix is None:
            return False
        start = 1 if raw and raw[0].startswith("#!") else 0
        rest = raw[start:]
    if variant == "modified" and years is None:
        years = str(current_year)
    new_lines = raw[:start] + render(variant, years, prefix, crlf) + rest
    with open(path, "w", encoding=ENCODING, newline="") as fh:
        fh.write("\n".join(new_lines))
    return True


# --------------------------------------------------------------------------
# file discovery
# --------------------------------------------------------------------------

def tracked_files():
    return [p for p in git("ls-files").splitlines()
            if not EXCLUDED.search(p) and os.path.isfile(p)]


def candidate_has_header(path):
    try:
        with open(path, encoding=ENCODING, newline="") as fh:
            head = [next(fh, "") for _ in range(5)]
    except OSError:
        return False
    return any(HEADER_LINE_RE.match(l) for l in head)


def changed_files(base):
    out = git("diff", "--name-only", base, "--")
    return [p for p in out.splitlines()
            if not EXCLUDED.search(p) and os.path.isfile(p)]


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--all", action="store_true",
                    help="check every tracked source file")
    ap.add_argument("--changed", metavar="BASE",
                    help="check files changed relative to BASE "
                         "(enforces current-year modification notices)")
    ap.add_argument("--fix", action="store_true",
                    help="repair reported problems in place")
    ap.add_argument("paths", nargs="*", help="explicit files to check")
    args = ap.parse_args()

    if not (args.all or args.changed or args.paths):
        ap.error("nothing to do: give --all, --changed BASE, or paths")

    os.chdir(git("rev-parse", "--show-toplevel").strip())
    current_year = datetime.date.today().year

    tag_files = tag_file_set()
    if tag_files is None:
        print("WARNING: tag %r not found; skipping git-consistency checks"
              % UPSTREAM_TAG, file=sys.stderr)

    work = []  # (path, require_current_year)
    seen = set()

    def add(path, strict):
        if path not in seen:
            seen.add(path)
            work.append((path, strict))

    if args.all:
        for p in tracked_files():
            if candidate_has_header(p) or \
                    os.path.splitext(p)[1] in REQUIRED_EXT:
                add(p, False)
    if args.changed:
        for p in changed_files(args.changed):
            if candidate_has_header(p) or \
                    os.path.splitext(p)[1] in REQUIRED_EXT:
                # strict year check only when the change is substantive
                strict = content_differs(args.changed, p)
                add(p, strict)
    for p in args.paths:
        add(os.path.relpath(p), True)

    bad = []
    for path, strict in work:
        rep = check_file(path, tag_files, current_year,
                         require_current_year=strict)
        if rep.errors:
            bad.append(rep)

    fixed = 0
    for rep in bad:
        if args.fix and fix_file(rep.path, rep, current_year, tag_files):
            # re-validate
            rep2 = check_file(rep.path, tag_files, current_year)
            if not rep2.errors:
                fixed += 1
                continue
            rep.errors = rep2.errors
        for msg in rep.errors:
            print("%s: %s" % (rep.path, msg))

    remaining = len(bad) - fixed
    print("checked %d file(s): %d problem file(s)%s"
          % (len(work), remaining,
             ", %d fixed" % fixed if fixed else ""))
    if remaining:
        if not args.fix:
            print("hint: run 'python scripts/copyright/check_headers.py "
                  "--fix <files>' to repair")
        sys.exit(1)


if __name__ == "__main__":
    main()
