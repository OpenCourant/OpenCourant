# OpenCourant Versioning and Releases

Decided in [discussion #55](https://github.com/orgs/OpenCourant/discussions/55).

## Version format

Releases are numbered `YYYY.N[.P]`:

| Part | Meaning |
|---|---|
| `YYYY` | Year the release was cut. Tells you how old a build is. |
| `N` | Sequence number within the year, starting at 1. Not a month: we do not commit to a schedule. |
| `P` | Fix-only update to `YYYY.N`. Omitted when zero. |

Examples, in order: `2026.1`, `2026.1.1`, `2026.2`, `2027.1`.

Git tags carry a `v` prefix (`v2026.1`); the version string inside binaries and
documentation does not (`2026.1`).

### Why not SemVer

SemVer promises that nothing breaks without a major bump. For a solver the
things that can break are input deck parsing, output formats, restart
compatibility and — above all — numerical results. Agreeing on which of those
counts as "breaking", for every change, is a harder problem than the version
number is worth. We state compatibility in the release notes instead.

### What a version number does and does not tell you

It tells you which published artifact you are running, and roughly how old it
is. Every release records the exact extlib release and hm_reader build ID it
was built against.

It does not promise that results are unchanged from the previous release.
Changes that can move results are called out in a dedicated release-note
section; read it before upgrading a validated model.

## Development snapshots

Automatic builds from `main` are published as prereleases tagged
`dev-YYYYMMDD-<short sha>`. They are for testing, carry no release notes, and
are pruned. Because they are marked as prereleases, `releases/latest` and the
`:latest` container tag always resolve to a formal release.

## Retention

Formal releases and their tags are kept permanently: a result you produced must
stay reproducible. Snapshots are pruned.

## Other version numbers in the tree

These are independent of the release version and are not bumped with it:

| Number | Where | Meaning |
|---|---|---|
| `CODVERS` | `starter/source/starter/starter0.F` | Input deck format profile; selects `hm_cfg_files/config/CFG/radioss<CODVERS>` |
| `INVERS` | `/BEGIN` card of a deck | Format version the deck declares |
| `ITESTV` | `starter0.F`, `engine/source/engine/radioss2.F` | Restart layout stamp; Starter and Engine must agree |
| `ANIM_VERS`, `TH_VERS` | engine output writers | Animation and time-history file formats |
| `version` | `EXTLIB_VERSION.json` | extlib package |

## Cutting a release

1. `VERSION` holds the in-development version with a `-dev` suffix
   (for example `2026.1-dev`). Every build stamps it into the binaries, so a
   non-release build identifies itself as such.
2. A release PR drops the suffix and finalises `CHANGELOG.md`.
3. After merge, the release workflow is run with the version as input. It
   refuses to build if `VERSION` still carries `-dev` or does not match.
4. A follow-up PR sets `VERSION` to the next development version.
