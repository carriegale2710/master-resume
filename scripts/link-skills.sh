#!/usr/bin/env bash
# Expose ./skills to agent tools that expect their own folder.
# Usage: bash scripts/link-skills.sh [--copy] [claude codex gemini ...]
# Default: symlink for claude, codex and gemini. --copy copies instead of linking.
set -euo pipefail
cd "$(dirname "$0")/.."

mode=link
tools=()
for a in "$@"; do
  case "$a" in
    --copy) mode=copy ;;
    *) tools+=("$a") ;;
  esac
done
[ ${#tools[@]} -gt 0 ] || tools=(claude codex gemini)

for t in "${tools[@]}"; do
  d=".$t"
  mkdir -p "$d"
  rm -rf "$d/skills"
  if [ "$mode" = link ] && ln -s ../skills "$d/skills" 2>/dev/null; then
    echo "Linked $d/skills -> ../skills"
  else
    cp -r skills "$d/skills"
    echo "Copied skills to $d/skills (re-run after editing skills/)"
  fi
done
