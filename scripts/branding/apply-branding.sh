#!/bin/bash
# Workstation Center OS - Shared Branding Script
# Applies consistent branding across all editions
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
USER_HOME="$HOME"
USER_NAME="$(whoami)"

# Load .env if present
ENV_FILE="$(dirname "$SCRIPT_DIR")/../.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
fi

echo "=== Applying Workstation Center Branding ==="

# --- Download logo ---
LOGO_URL="https://workstation.center/logo.png"
LOGO_FILE="/tmp/workstation-logo.png"
if [ ! -f "$LOGO_FILE" ]; then
  wget -q "$LOGO_URL" -O "$LOGO_FILE" 2>/dev/null || true
fi

# --- Detect Guacamole webapp path ---
GUAC_WEBAPP=""
for path in /var/lib/tomcat9/webapps/guacamole /var/lib/tomcat10/webapps/guacamole; do
  if [ -d "$path" ]; then
    GUAC_WEBAPP="$path"
    break
  fi
done

# --- Apply Guacamole branding (if installed) ---
if [ -n "$GUAC_WEBAPP" ] && [ -f "$LOGO_FILE" ]; then
  echo "  Applying Guacamole branding..."
  
  # Replace logos
  sudo cp "$LOGO_FILE" "${GUAC_WEBAPP}/images/guac-tricolor.svg" 2>/dev/null || true
  sudo cp "$LOGO_FILE" "${GUAC_WEBAPP}/images/logo-64.png" 2>/dev/null || true
  sudo cp "$LOGO_FILE" "${GUAC_WEBAPP}/images/logo-144.png" 2>/dev/null || true
  
  # Create W favicon
  if command -v convert &> /dev/null; then
    convert -size 32x32 xc:white -font DejaVu-Sans-Bold -pointsize 24 -fill black -gravity center -annotate 0 "W" /tmp/favicon-32.png 2>/dev/null || true
    convert -size 16x16 xc:white -font DejaVu-Sans-Bold -pointsize 12 -fill black -gravity center -annotate 0 "W" /tmp/favicon-16.png 2>/dev/null || true
    sudo cp /tmp/favicon-32.png "${GUAC_WEBAPP}/images/favicon-32.png" 2>/dev/null || true
    sudo cp /tmp/favicon-16.png "${GUAC_WEBAPP}/images/favicon-16.png" 2>/dev/null || true
  fi
  
  # Update translations
  sudo sed -i 's|"NAME"    : "Apache Guacamole"|"NAME"    : "Workstation Center OS"|g' "${GUAC_WEBAPP}/translations/en.json" 2>/dev/null || true
  sudo sed -i 's|"NAME"    : "Apache Guacamole"|"NAME"    : "Workstation Center OS"|g' "${GUAC_WEBAPP}/translations/es.json" 2>/dev/null || true
  
  # Update index.html
  sudo sed -i 's#<title ng-bind="page.title | translate"></title>#<title>Workstation Center OS</title>#g' "${GUAC_WEBAPP}/index.html" 2>/dev/null || true
  sudo sed -i 's|<link rel="icon" type="image/png" href="images/logo-64.png">|<link rel="icon" type="image/png" href="images/favicon-32.png">|g' "${GUAC_WEBAPP}/index.html" 2>/dev/null || true
  sudo sed -i 's|<link rel="icon" type="image/png" sizes="144x144" href="images/logo-144.png">|<link rel="icon" type="image/png" sizes="16x16" href="images/favicon-16.png"><link rel="icon" type="image/png" sizes="32x32" href="images/favicon-32.png">|g' "${GUAC_WEBAPP}/index.html" 2>/dev/null || true
fi

# --- Download wallpaper ---
WALLPAPER_DIR="${USER_HOME}/.workstation-center"
mkdir -p "$WALLPAPER_DIR"
WALLPAPER_FILE="${WALLPAPER_DIR}/wallpaper.jpg"

if [ ! -f "$WALLPAPER_FILE" ]; then
  echo "  Downloading default wallpaper..."
  wget -q "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1920&h=1080&fit=crop" -O "$WALLPAPER_FILE" 2>/dev/null || true
fi

# Copy additional wallpapers if present
EXTRA_WALLPAPERS="${SCRIPT_DIR}/wallpapers"
if [ -d "$EXTRA_WALLPAPERS" ]; then
  cp -n "$EXTRA_WALLPAPERS"/* "$WALLPAPER_DIR/" 2>/dev/null || true
fi

echo "  Branding applied successfully"
