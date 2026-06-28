# workstation-webspace-guacamole

Remote desktop gateway in your browser. Multi-protocol support (VNC, RDP, SSH) via Apache Guacamole.

**Works on:** Linux VMs, servers, bare metal, Docker, Codespaces.
**Note:** Containers run in direct mode (no auto-restart on crash).

## Quick start

```bash
git clone -b main https://github.com/Workstation-ai/workstation-webspace-guacamole.git
cd workstation-webspace-guacamole
cp .env.example .env
```

Edit `.env` with your settings:

```bash
nano .env
```

Save and exit (Ctrl+X, Y, Enter), then:

```bash
./run
```

That's it. You get a URL and login credentials.

## What it does

Sets up a web-based remote desktop gateway:
- Apache Guacamole (HTML5 client) + guacd (proxy daemon)
- Tomcat 9 (servlet container) + SQLite (lightweight auth)
- Xvfb + fluxbox (virtual desktop for VNC connections)
- Multi-protocol: VNC, RDP, SSH, Telnet
- Cloudflare tunnel for public access (optional)

## Commands

| Command | What |
|---------|------|
| `./run` | Install everything and start |
| `./run --agent-preset-workspace` | Install desktop + OpenCode GentleAI agent |
| `./stop` | Stop all services |
| `./status` | Show status + URL |
| `./uninstall` | Clean removal |

### Agent workspace (with OpenCode GentleAI)

Clone and run with agent support:

```bash
git clone -b main https://github.com/Workstation-ai/workstation-webspace-guacamole.git
cd workstation-webspace-guacamole
cp .env.example .env
nano .env
./run --agent-preset-workspace
```

This installs the desktop + [OpenCode GentleAI](https://github.com/reflecterlabs/alpine-opencode-gentleai) agent environment.

## Configuration (.env)

```bash
GUAC_PASSWORD=yourpassword    # required - web UI login
VNC_PASSWORD=yourvncpass      # required - VNC connections
SCREEN_RESOLUTION=1920x1080   # optional
COLOR_DEPTH=24                # optional
```

## How it works

**Architecture:**
```
Browser → Tomcat (8080) → guacd (4822) → VNC/RDP/SSH
                ↓
         Guacamole Web UI
```

1. **guacd** — Native proxy daemon, handles VNC/RDP/SSH protocols
2. **Tomcat** — Serves the Guacamole web interface
3. **SQLite** — Stores users and connection configs
4. **Xvfb + fluxbox** — Virtual desktop for VNC connections

## Usage on a new machine

```bash
git clone -b main https://github.com/Workstation-ai/workstation-webspace-guacamole.git
cd workstation-webspace-guacamole
cp .env.example .env
nano .env
```

Set your `GUAC_PASSWORD` and `VNC_PASSWORD`, save (Ctrl+X, Y, Enter), then:

```bash
./run
```

## Access

After running, open:
- **Local:** `http://localhost:8080/guacamole`
- **Public:** Cloudflare URL (if available)

Login with:
- **Username:** `guacadmin`
- **Password:** Your `GUAC_PASSWORD` from `.env`

To add connections: Settings → Connections → New Connection

## Notes

- Cloudflare quick tunnel URLs change on restart
- Desktop starts empty — add connections via Guacamole web UI
- Supports VNC, RDP, SSH, Telnet, Kubernetes protocols
- SQLite is lightweight but limited — use MariaDB for production
- guacd runs on port 4822, Tomcat on 8080
