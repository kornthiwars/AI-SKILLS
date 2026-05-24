#!/usr/bin/env bash
# One-time setup after cloning AI-SKILLS (macOS / Linux).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

step() { printf '\n=> %s\n' "$1"; }
ok() { printf '  OK  %s\n' "$1"; }
fail() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

test_repo_layout() {
  for dir in ai-skills ai-rules templates vault; do
    [[ -d "$REPO_ROOT/$dir" ]] || fail "Missing required folder '$dir'. Are you in the AI-SKILLS repo?"
  done
}

# $1 = parent dir (.cursor), $2 = link name (skills), $3 = target dir name (ai-skills)
link_into_parent() {
  local parent="$1" link_name="$2" target_name="$3"
  local parent_path="$REPO_ROOT/$parent"
  local link_path="$parent_path/$link_name"
  local target_path="$REPO_ROOT/$target_name"

  [[ -d "$target_path" ]] || fail "Target does not exist: $target_name"

  mkdir -p "$parent_path"

  if [[ -L "$link_path" ]]; then
    local current
    current="$(readlink "$link_path")"
    if [[ "$current" == "../$target_name" || "$current" == "$target_path" ]]; then
      ok "$parent/$link_name -> $target_name (already linked)"
      return 0
    fi
    step "Replacing symlink $parent/$link_name"
    rm "$link_path"
  elif [[ -e "$link_path" ]]; then
    fail "$parent/$link_name exists and is not a symlink. Remove or rename it, then re-run scripts/setup.sh"
  fi

  ln -sfn "../$target_name" "$link_path"
  ok "$parent/$link_name -> $target_name"
}

ensure_vault_folders() {
  for dir in vault/issues vault/learnings; do
    if [[ ! -d "$REPO_ROOT/$dir" ]]; then
      mkdir -p "$REPO_ROOT/$dir"
      ok "created $dir"
    else
      ok "$dir"
    fi
  done
}

test_mirror_links() {
  local checks=(
    ".cursor/skills/upgrade/SKILL.md:Cursor skills"
    ".cursor/rules/vault-learning.mdc:Cursor rules"
    ".claude/skills/upgrade/SKILL.md:Claude skills"
    ".claude/rules/vault-learning.mdc:Claude rules"
  )
  local entry name path
  for entry in "${checks[@]}"; do
    path="${entry%%:*}"
    name="${entry#*:}"
    [[ -f "$REPO_ROOT/$path" ]] || fail "Verify failed ($name): missing $REPO_ROOT/$path"
  done
  ok "all mirror links resolve to canonical files"
}

printf '\nAI-SKILLS setup (macOS / Linux)\n'
printf 'Repo: %s\n' "$REPO_ROOT"

step "Checking repo layout"
test_repo_layout

step "Creating Cursor / Claude symlinks"
link_into_parent .cursor skills ai-skills
link_into_parent .cursor rules  ai-rules
link_into_parent .claude skills ai-skills
link_into_parent .claude rules  ai-rules

step "Ensuring vault folders"
ensure_vault_folders

step "Verifying links"
test_mirror_links

printf '\nDone.\n'
printf 'Next: open this folder in Cursor, reload the window, then use @ui-builder / @git-push etc.\n'
printf 'Obsidian: open repo root as vault (see vault/README.md).\n\n'
