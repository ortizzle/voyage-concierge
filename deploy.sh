#!/bin/bash
# Voyage Concierge — first-time deploy to GitHub Pages under ortizzle
# Run from this folder:  bash deploy.sh
set -e

GH=/opt/homebrew/bin/gh
REPO=voyage-concierge
cd "$(dirname "$0")"

echo "→ Checking GitHub auth..."
"$GH" auth status

if [ ! -d .git ]; then
  echo "→ Initializing repo..."
  git init -b main
fi

git add index.html manifest.webmanifest sw.js icon.svg icon-maskable.svg
git commit -m "Voyage Concierge — installable PWA with booking-window rules engine" || echo "(nothing new to commit)"

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "→ Creating GitHub repo ortizzle/$REPO..."
  "$GH" repo create "ortizzle/$REPO" --public --source=. --remote=origin --push
else
  git push -u origin main
fi

echo "→ Enabling GitHub Pages on main..."
"$GH" api -X POST "repos/ortizzle/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
  || "$GH" api -X PUT "repos/ortizzle/$REPO/pages" \
       -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
  || echo "(Pages may already be enabled — check repo settings)"

echo ""
echo "✅ Done. Live in about a minute at:"
echo "   https://ortizzle.github.io/$REPO/"
echo ""
echo "On your Pixel, open that URL and use Chrome's menu → Add to Home screen."
echo "If you see a stale version, add ?v=2 to the end of the URL."
