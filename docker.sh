#!/usr/bin/env bash
set -euo pipefail

# Determine architecture
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH_TAG="x86_64" ;;
  arm64)  ARCH_TAG="aarch64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Determine latest version if not supplied
VERSION=${1:-"$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep '"tag_name":' \
  | sed -E 's/.*"v([^"]+)".*/\1/')"} 

echo "Installing Docker Compose v$VERSION for architecture $ARCH_TAG ..."

# Plugin path
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
PLUGIN_DIR="$DOCKER_CONFIG/cli-plugins"
mkdir -p "$PLUGIN_DIR"

# Download binary
URL="https://github.com/docker/compose/releases/download/v${VERSION}/docker-compose-darwin-$ARCH_TAG"
echo "Downloading $URL ..."
curl -#SL "$URL" -o "$PLUGIN_DIR/docker-compose"

# Make executable
chmod +x "$PLUGIN_DIR/docker-compose"

# Verify
docker compose version
