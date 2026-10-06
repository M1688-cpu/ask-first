#!/bin/bash
# install.sh: install the ask-first skills into every coding agent on this machine.
#
#   bash install.sh            install into agents already detected here
#   bash install.sh --all      install into every supported agent, creating dirs
#   bash install.sh --list     show the target folders and what is detected
#   bash install.sh --remove   uninstall the skills from every supported agent
#
# An agent counts as detected when its skills folder exists, or when the folder
# above it exists (the agent is installed but has no skills yet).

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$SCRIPT_DIR/skills"
SKILLS="clarify-first knock-first"

MODE="${1:-install}"

for s in $SKILLS; do
  if [ ! -f "$SRC/$s/SKILL.md" ]; then
    echo "error: $SRC/$s/SKILL.md not found; run this script from a full clone" >&2
    exit 1
  fi
done

done_count=0
skip_count=0

while IFS=':' read -r name dir; do
  [ -n "$name" ] || continue
  parent=$(dirname "$dir")

  case "$MODE" in
    --list)
      if [ -d "$dir" ]; then state="skills folder exists"
      elif [ -d "$parent" ]; then state="agent detected, folder will be created"
      else state="not found"; fi
      printf '%-12s %-38s %s\n' "$name" "$dir" "$state"
      ;;

    --remove)
      if [ -d "$dir" ]; then
        for s in $SKILLS; do rm -rf "$dir/$s"; done
        echo "removed from $name ($dir)"
        done_count=$((done_count + 1))
      else
        skip_count=$((skip_count + 1))
      fi
      ;;

    --all|install)
      if [ "$MODE" = "--all" ] || [ -d "$dir" ] || [ -d "$parent" ]; then
        mkdir -p "$dir"
        for s in $SKILLS; do
          rm -rf "$dir/$s"
          cp -R "$SRC/$s" "$dir/$s"
        done
        echo "installed: $name -> $dir"
        done_count=$((done_count + 1))
      else
        skip_count=$((skip_count + 1))
      fi
      ;;

    *)
      echo "usage: bash install.sh [--all|--list|--remove]" >&2
      exit 1
      ;;
  esac
done <<EOF
claude-code:$HOME/.claude/skills
codex:$HOME/.codex/skills
cursor:$HOME/.cursor/skills
gemini-cli:$HOME/.gemini/skills
opencode:$HOME/.config/opencode/skill
amp:$HOME/.amp/skills
openclaw:$HOME/.openclaw/skills
zcode:$HOME/.zcode/skills
any-agent:$HOME/.agents/skills
EOF

case "$MODE" in
  --list) ;;
  install)
    if [ "$done_count" -eq 0 ]; then
      echo "no supported agent detected; run 'bash install.sh --all' or copy manually" >&2
      exit 1
    fi
    echo "$done_count installed, $skip_count skipped"
    ;;
  --all|--remove)
    echo "$done_count done, $skip_count skipped"
    ;;
esac
