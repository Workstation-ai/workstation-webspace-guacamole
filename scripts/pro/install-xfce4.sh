#!/bin/bash
# Workstation Center OS - Pro Edition (XFCE4)
# Full desktop experience with app launcher, settings, and desktop icons
set -euo pipefail

echo "=== Installing Pro Edition (XFCE4) ==="

# --- Install packages ---
echo "[1/5] Installing XFCE4 and dependencies..."
sudo apt-get update -qq
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq \
  xfce4 xfce4-appfinder xfce4-terminal xfce4-panel \
  xfce4-session xfce4-settings xfconf xfdesktop4 xfwm4 \
  xfce4-whiskermenu-plugin \
  thunar xdg-utils xsel dbus-x11 xdotool wmctrl \
  gnome-themes-extra gnome-themes-extra-data \
  2>&1 | tail -5

# --- Configure XFCE4 ---
echo "[2/5] Configuring XFCE4..."
USER_HOME="$HOME"
USER_NAME="$(whoami)"
XFCE_DIR="${USER_HOME}/.config/xfce4"
mkdir -p "${XFCE_DIR}/xfconf/xfce-perchannel-xml"

# Disable screensaver and power management
cat > "${XFCE_DIR}/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-screensaver" version="1.0">
  <property name="saver" type="empty"/>
  <property name="lock" type="empty"/>
</channel>
EOF

cat > "${XFCE_DIR}/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="xfce4-power-manager" type="empty"/>
</channel>
EOF

# --- Configure panel layout ---
echo "[3/5] Configuring panel layout..."
cat > "${XFCE_DIR}/xfconf/xfce-perchannel-xml/xfce4-panel.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="32"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whisker-menu"/>
    <property name="plugin-2" type="string" value="showdesktop"/>
    <property name="plugin-3" type="string" value="tasklist"/>
    <property name="plugin-4" type="string" value="systray">
      <property name="known-items" type="array">
        <value type="string" value="nm-applet"/>
      </property>
    </property>
    <property name="plugin-5" type="string" value="clock"/>
    <property name="plugin-6" type="string" value="actionbuttons">
      <property name="actions" type="array">
        <value type="string" value="logout"/>
      </property>
    </property>
  </property>
</channel>
EOF

# --- Configure desktop icons ---
echo "[4/5] Configuring desktop icons..."
DESKTOP_DIR="${USER_HOME}/Desktop"
mkdir -p "$DESKTOP_DIR"

# Create .desktop files
cat > "${DESKTOP_DIR}/terminal.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Open terminal emulator
Exec=xfce4-terminal
Icon=utilities-terminal
Terminal=false
Categories=System;
EOF

cat > "${DESKTOP_DIR}/files.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Files
Comment=Open file manager
Exec=thunar
Icon=system-file-manager
Terminal=false
Categories=System;
EOF

cat > "${DESKTOP_DIR}/settings.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Settings
Comment=Open settings manager
Exec=xfce4-settings-manager
Icon=preferences-system
Terminal=false
Categories=System;
EOF

cat > "${DESKTOP_DIR}/browser.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Browser
Comment=Open web browser
Exec=firefox
Icon=firefox
Terminal=false
Categories=Network;
EOF

chmod +x "${DESKTOP_DIR}"/*.desktop

# --- Set wallpaper ---
echo "[5/5] Setting wallpaper..."
WALLPAPER="${USER_HOME}/.workstation-center/wallpaper.jpg"
if [ -f "$WALLPAPER" ]; then
  # Set wallpaper via xfconf
  (sleep 5 && DISPLAY=:99 xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER" 2>/dev/null) &
fi

echo "=== Pro Edition installed successfully ==="
echo "  Desktop: XFCE4"
echo "  RAM: ~200 MB"
echo "  Startup: ~8-10s"
echo "  Features: Panel, App Launcher, Settings, Desktop Icons"
