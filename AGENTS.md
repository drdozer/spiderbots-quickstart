# spiderbots-quickstart — agent notes

**Spiderbots Quickstart**: gives new games a configurable number of
Spidertrons at spawn — `on_init` injects the `spiderbot` item into the
freeplay created-items set (0–10, runtime-global setting). Author drdozer.
v0.0.1. **Declared fv "2.0" — does NOT load on the 2.1 dlc install** (see
superproject `issues/spiderbots-quickstart-not-2.1.md`; retarget is a
separate decision, never a port fix).

All-mods procedures: superproject `AGENTS.md` + `docs/`. This file holds only
mod-specifics. Session history: `docs/journal.md`.

## Layout

Superproject standard: `mod/` is the portal-clean deployable (info.json,
control.lua, settings.lua, locale/en/settings.cfg). Root keeps LICENSE and
README.md. **No data stage at all** — the mod is runtime glue + one setting.
Not live-linked in the dlc install (deliberate: it can't load on 2.1; link
only after the retarget).

## Invariants

1. **Everything hangs on the `spiderbots` hard dep**: control.lua injects the
   `spiderbot` *item prototype* by name; if the dep is absent the mod logs
   and no-ops (`prototypes.item["spiderbot"] ~= nil` guard). The dep zip is
   itself fv-2.0-declared — any 2.1 retarget must resolve the dep first
   (issue file, step 1).
2. **Freeplay interface dependency**: injection goes through
   `remote.interfaces['freeplay']` — works in standard games, silently logs
   otherwise (scenarios that disable freeplay get no bots). Don't replace
   with direct `LuaPlayer.insert` without losing the "created items" model.
3. **String hygiene is already right**: the only user-visible string is the
   setting name/description, fully hooked in `mod/locale/en/settings.cfg`.
   Keep it that way.
4. **Setting bounds 0–10** (`int-setting` minimum/maximum) match the README
   and the description text — change all three together.

## Dependencies

`base >= 2.0`, `spiderbots` (hard), `? PyBlock` (optional; **no code
references PyBlock anywhere** — vestigial like oreguard's cargo-ships dep;
fold into the retarget decision). No py involvement otherwise.

## Verification quick recipe

- Hermetic load probes: superproject `docs/testing.md` §3; rig pattern
  `.cache/spiderbots-quickstart-port/` (dlc + vanilla scratch configs).
  **Hard-dep mods need the dep zip symlinked into the scratch mods dir** —
  data-dir auto-enable covers base/SA DLC only, not portal mods (learned
  2026-10-15; first probe rejected on the missing dep, not the fv gate).
- Expected dlc (2.1.21) result until retargeted: fv-gate rejection — that is
  the *correct* gate outcome, not a failure (issue file has the exact text).
- `devctl mods build spiderbots-quickstart` (mod/ layout; 7-file zip,
  game content only).

## Docs index

- `README.md` — human-facing description
- `docs/journal.md` — session work log
- Superproject `issues/spiderbots-quickstart-not-2.1.md` — the open retarget
