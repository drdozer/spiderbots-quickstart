# spiderbots-quickstart — journal (session work log)

Chronological log of agent work sessions. Companion docs: `README.md`,
superproject `issues/spiderbots-quickstart-not-2.1.md`.

## Session 2026-10-15 (b) — 2.1-retarget investigation (no port)

Follow-up to the port session, per the retarget tickets
(superproject `inbox/retarget-spiderbots-quickstart-to-2.1.md`, Order 2).
Question: is a fv 2.0 → 2.1 retarget trivial? Answer: **no — blocked on the
hard dep**.

- Portal API check: `spiderbots` latest is 0.3.2 (2026-06-25) and **every
  release since 0.2.1 declares fv 2.0** — no 2.1 release exists.
- Therefore bumping this mod's fv alone is dead-on-arrival (2.1 would reject
  with `Missing required dependency spiderbots` instead of the fv gate).
- Paths recorded in the ticket: wait/ask upstream (asher_sky) vs fork+port
  spiderbots (real third-party port work, weighed against the mod's tiny
  value). No code or declaration changes made; issue
  `issues/spiderbots-quickstart-not-2.1.md` remains OPEN with the portal
  facts added.
- **Decision (later same day)**: Path A chosen — wait for upstream; do not
  fork+port. Ticket parked in superproject `blocked/` with a one-call
  trigger check (portal API newest release's fv).

### End state

- No mod changes; superproject commit carries the ticket + issue update.
- Re-check trigger: a 2.1-declared spiderbots release on the portal.

## Session 2026-10-15 — structural port to superproject standard

Starting point: 0.0.1 at `4ec45c9`, repo-root layout, fv "2.0", deps
`base >= 2.0`, `spiderbots` (hard), `? PyBlock`. Task file flagged the mod
as probably not 2.1-runnable; declaration bumps explicitly out of scope.

### Port (per superproject `docs/mod-porting-workflow.md`)

- Inventory: 6 files; deployable = info.json + control.lua (22 lines,
  `on_init` freeplay item injection) + settings.lua (one runtime-global int
  0–10) + locale/en/settings.cfg; root LICENSE + README. No data stage, no
  graphics, no tools, no notes pile. `? PyBlock` declared with zero code
  references (noted in AGENTS deps; fold into the retarget decision — no
  separate issue file for a 4-line mod).
- **Move** (commit `804d04d`, pure `git mv`): deployable → `mod/`; root
  keeps LICENSE + README.md. No content changes.
- **Verification gate** (adapted: fv-2.0 mod on a 2.1 install → rejection is
  the expected gate outcome, so the gate compares *rejections*, not dumps):
  - dlc 2.1.21, pre-move: exit 1,
    `Failed to load mod "spiderbots": • Incompatible Factorio version
    (current: 2.1, required: 2.0)` — the hard dep (also fv 2.0) is gated
    first; quickstart listed incompatible alongside it. First run (before
    symlinking the dep) rejected with `Missing required dependency
    spiderbots` — **probe-rig lesson**: hard portal deps must be symlinked
    into the scratch mods dir; data-dir auto-enable covers only base/SA DLC.
  - dlc post-move: rejection text **identical** (sorted error lines diff
    clean; only timing stamps differ). Structural no-op proven — no
    dump-diff possible on a rejected load.
  - vanilla 2.0.77: exit 1, `Missing required dependency spiderbots` — the
    fv gate *passed* on 2.0 (dep zip absent from the vanilla install;
    deliberately not chased per task file). Proves the mod set is
    2.0-consistent; 2.1 incompatibility is purely the declared fv.
  - `devctl mods build spiderbots-quickstart`: 7-file zip, game content
    only, sha256 `7a6971c4…`.
  - No relink: the mod was never live-linked; it stays unlinked until the
    2.1 retarget (linking a fv-rejected mod breaks every dlc load).
- **Knowledge extraction**: AGENTS.md created (lean shape); this journal
  seeded; issue filed: `spiderbots-quickstart-not-2.1.md` (rejection
  evidence + retarget direction: resolve the dep's fv first).

### Scratch evidence

- `.cache/spiderbots-quickstart-port/` — dlc scratch (config + mods dir with
  quickstart symlink + spiderbots zip symlink) and vanilla scratch (config +
  quickstart symlink only); rejection logs `baseline-dlc-rejection.log`,
  `baseline-vanilla-rejection.log`. Recreate per superproject
  `docs/testing.md` §3 + the hard-dep symlink note in AGENTS.md.

### End state

- Mod repo: layout commit `804d04d` + docs commit at HEAD.
- Superproject: pointer bump + issue file; inbox task
  `port-spiderbots-quickstart.md` removed after push.
- Next: `inbox/port-transport-drones-on-asphalt.md` (Order 4; src/ layout
  stays; fv 2.0 → expected rejection → issue file).
