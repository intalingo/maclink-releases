#!/bin/bash
# MacLink installer and updater. Downloads the newest MacLink release, checks it, and installs it.
#
#   Remote Mac (first install, adds the audio driver):
#     curl -fsSL https://github.com/intalingo/maclink-releases/releases/latest/download/install.sh | bash -s -- remote
#   Local Mac (first install), or any Mac to update:
#     curl -fsSL https://github.com/intalingo/maclink-releases/releases/latest/download/install.sh | bash
set -euo pipefail

# Everything is inside main, so a download cut off halfway runs nothing.
main() {
  repo="intalingo/maclink-releases"
  base="https://github.com/$repo/releases/latest/download"
  mode="${1:-app}"   # remote | local | app (update)

  case "$mode" in
    remote) flag="-d" ;;
    local|app|update) flag="" ;;
    *) echo "Usage: … | bash -s -- [remote|local]"; exit 2 ;;
  esac

  [ "$(uname)" = Darwin ] || { echo "✗ MacLink runs on macOS only."; exit 1; }

  work=$(mktemp -d /tmp/maclink-install.XXXXXX)
  trap 'rm -rf "$work"' EXIT
  cd "$work"

  echo "→ Downloading the latest MacLink…"
  curl -fL --progress-bar -o MacLink.zip "$base/MacLink.zip"
  curl -fsSL -o MacLink.zip.sha256 "$base/MacLink.zip.sha256"

  expected=$(awk '{print $1}' MacLink.zip.sha256)
  actual=$(shasum -a 256 MacLink.zip | awk '{print $1}')
  if [ "$expected" != "$actual" ]; then
    echo "✗ The download is damaged (checksum mismatch). Nothing was changed; run the command again."
    exit 1
  fi
  echo "✓ Download verified"

  unzip -q MacLink.zip
  version=$(defaults read "$work/MacLink/MacLink.app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "?")
  echo "→ Installing MacLink $version${flag:+ with its audio driver (macOS asks for your password)}…"
  ./MacLink/install.sh $flag
}

main "$@"
