#!/usr/bin/env python3
"""Draft CHANGELOG entries from the pull requests merged since a release.

Usage:
  scripts/release_notes.py <base-ref> [head-ref]

Pull requests are squash-merged (see CONTRIBUTING.md), so each one appears as a
single commit whose subject ends in '(#N)'.  For every N found between base-ref
and head-ref this asks GitHub for the labels and the 'Release note' section of
the pull request body, then groups the results under the CHANGELOG headings.

The output is a draft.  Edit it, in particular the two solver-specific
sections, before putting it in CHANGELOG.md.  Requires the gh CLI.
"""

import json
import re
import subprocess
import sys

REPO = "OpenCourant/OpenCourant"

# First matching label wins, so the solver-specific sections take precedence.
SECTIONS = [
    ("May change numerical results", ["results-affecting"]),
    ("Input deck changes", ["deck-change"]),
    ("Added", ["enhancement", "feature"]),
    ("Fixed", ["bug", "bugfix"]),
    ("Build and packaging", ["build", "ci", "packaging", "documentation"]),
]
FALLBACK = "Changed"

PR_RE = re.compile(r"\(#(\d+)\)\s*$")
NOTE_RE = re.compile(r"^#+\s*Release note\s*$(.*?)(?=^#+\s|\Z)",
                     re.MULTILINE | re.DOTALL)
COMMENT_RE = re.compile(r"<!--.*?-->", re.DOTALL)


def git(*args):
    return subprocess.run(["git"] + list(args), capture_output=True,
                          text=True, check=True).stdout


def merged_pr_numbers(base, head):
    numbers = []
    for subject in git("log", "--format=%s", "%s..%s" % (base, head)).splitlines():
        m = PR_RE.search(subject)
        if m and m.group(1) not in numbers:
            numbers.append(m.group(1))
    return numbers


def pr_info(number):
    out = subprocess.run(
        ["gh", "api", "repos/%s/pulls/%s" % (REPO, number)],
        capture_output=True, text=True)
    if out.returncode != 0:
        return None
    data = json.loads(out.stdout)
    return {
        "number": number,
        "title": data["title"],
        "author": (data.get("user") or {}).get("login", ""),
        "labels": {l["name"] for l in data.get("labels", [])},
        "note": release_note(data.get("body") or "") or data["title"],
    }


def release_note(body):
    m = NOTE_RE.search(body)
    if not m:
        return None
    text = COMMENT_RE.sub("", m.group(1)).strip()
    if not text or text.lower() == "none":
        return None
    return " ".join(text.split())


def section_for(labels):
    for name, keys in SECTIONS:
        if labels.intersection(keys):
            return name
    return FALLBACK


def main():
    if not 2 <= len(sys.argv) <= 3:
        sys.exit(__doc__.strip())
    base, head = sys.argv[1], sys.argv[2] if len(sys.argv) == 3 else "HEAD"

    numbers = merged_pr_numbers(base, head)
    if not numbers:
        sys.exit("no squash-merged pull requests found in %s..%s" % (base, head))

    grouped = {}
    skipped = []
    for number in numbers:
        info = pr_info(number)
        if info is None:
            skipped.append(number)
            continue
        grouped.setdefault(section_for(info["labels"]), []).append(info)

    for name, _ in SECTIONS + [(FALLBACK, None)]:
        entries = grouped.get(name)
        if not entries:
            continue
        print("### %s\n" % name)
        for e in entries:
            print("- %s (#%s)%s" % (e["note"], e["number"],
                                    " @%s" % e["author"] if e["author"] else ""))
        print("")

    if skipped:
        print("<!-- could not be read from GitHub: %s -->"
              % ", ".join("#" + n for n in skipped))


if __name__ == "__main__":
    main()
