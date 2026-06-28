#!/bin/bash
# Workstation Center OS - Tiny Edition (fluxbox)
# Lightweight desktop environment for cost-optimized deployment
set -euo pipefail

echo "=== Installing Tiny Edition (fluxbox) ==="

# --- Install packages ---
echo "[1/3] Installing fluxbox and dependencies..."
sudo apt-get update -qq
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq \
  fluxbox xfce4-terminal xdg-utils xsel \
  dbus-x11 xdotool wmctrl \
  2>&1 | tail -5

# --- Configure fluxbox ---
echo "[2/3] Configuring fluxbox..."
USER_HOME="$HOME"
mkdir -p "${USER_HOME}/.fluxbox"

# Menu configuration
cat > "${USER_HOME}/.fluxbox/menu" << 'MENU'
[begin] (Desktop)
	[submenu] (Applications)
		[exec] (Terminal) {xfce4-terminal} <>
		[exec] (Firefox) {firefox} <>
		[exec] (File Manager) {thunar} <>
		[exec] (Text Editor) {xfce4-terminal -e nano} <>
	[end]
	[submenu] (System)
		[exec] (htop) {xfce4-terminal -e htop} <>
		[exec] (Settings) {xfce4-terminal -e xfce4-settings-manager} <>
	[end]
	[separator]
	[restart] (Restart) <>
	[exit] (Exit) <>
end
MENU

# Init configuration
cat > "${USER_HOME}/.fluxbox/init" << EOF
! Toolbar
session.screen0.toolbar.visible: true
session.screen0.toolbar.widthPercent: 100
session.screen0.toolbar.height: 32
session.screen0.toolbar.tools: prevworkspace, workspacename, nextworkspace, clock, iconbar, systemtray

! Iconbar
session.screen0.iconbar.mode: {static groups} (workspace=[current])

! Workspace
session.screen0.workspaceCount: 1
EOF

# --- Set wallpaper ---
echo "[3/3] Setting wallpaper..."
WALLPAPER="${USER_HOME}/.workstation-center/wallpaper.jpg"
if [ -f "$WALLPAPER" ]; then
  # Delay wallpaper setting until X is ready
  (sleep 3 && DISPLAY=:99 fbsetbg -f "$WALLPAPER" 2>/dev/null) &
fi

echo "=== Tiny Edition installed successfully ==="
echo "  Desktop: fluxbox"
echo "  RAM: ~20 MB"
echo "  Startup: ~3s"
