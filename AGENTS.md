# workstation-webspace-guacamole

Apache Guacamole remote desktop gateway — Tiny (fluxbox) and Pro (XFCE4) editions for Workstation Center.

## Context

- **Org**: Workstation-ai
- **User**: Ignacio del Corro (ignacio@workstation.center)
- **Box**: bux VPS — full sudo, Telegram bot (agency)
- **Skills installed**: cloudflare-tunnel, cognitive-doc-design, comment-writer

## 🔒 Credential Safety — CRITICAL

Never store API keys, tokens, passwords, or secrets in Engram memory. If you save an observation or session summary that mentions credentials:

- Replace the actual value with `(stored in .env.credentials, never embed in engram)`
- Save the real value ONLY in `.env.credentials` (gitignored, never tracked)
- Before running `engram sync` to export `.engram/`, verify no credentials leaked

Credentials for this project live in `/opt/bux/repo/.env.credentials` or a local `.env` copy.

## 🔄 Engram Sync Cadence — MANDATORY

This repo has an `.engram/` directory with portable memory from the `bux` project.

- **After every session** where you save new discoveries, decisions, bug fixes, or patterns → run `engram sync --project bux` from this repo root
- **Before ending a session** → sync `.engram/` and commit the updates
- **After `engram sync`** → `git add .engram/ && git commit -m "sync engram memories"` — if nothing new, skip it
- **Before syncing** → always verify no credentials leaked (see 🔒 Credential Safety above)
- **When pulling** `.engram/` updates from GitHub → run `engram sync --import` to load the new context

## Files

- `run` — Main setup script (parameterized)
- `run-tiny` — Tiny edition shortcut
- `run-pro` — Pro edition shortcut
- `stop`, `status`, `uninstall` — Service management
- `.env` — Local config (gitignored, copy from `.env.example`)
- `scripts/` — Installers, branding, services
