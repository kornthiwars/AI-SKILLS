#!/usr/bin/env bash
# One-time setup after cloning AI-SKILLS (macOS / Linux).
# Usage: chmod +x scripts/setup-macos-linux.sh && ./scripts/setup-macos-linux.sh
# Repo-only: REPO_ONLY=1. Explicit parent: WORKSPACE_ROOT=/path. Auto parent when web/api/… siblings exist.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

WORKSPACE_ROOT="${WORKSPACE_ROOT:-}"
REPO_ONLY="${REPO_ONLY:-0}"

step() { printf '\n=> %s\n' "$1"; }
ok() { printf '  OK  %s\n' "$1"; }
fail() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

SKILLS_CANONICAL="$REPO_ROOT/ai-skills"
RULES_CANONICAL="$REPO_ROOT/ai-rules"

test_repo_layout() {
  for dir in ai-skills ai-rules templates vault; do
    [[ -d "$REPO_ROOT/$dir" ]] || fail "Missing required folder '$dir'. Are you in the AI-SKILLS repo?"
  done
}

link_to_target() {
  local link_path="$1" target_path="$2"
  local target_abs parent current current_abs

  [[ -d "$target_path" ]] || fail "Target does not exist: $target_path"
  target_abs="$(cd "$target_path" && pwd)"

  parent="$(dirname "$link_path")"
  mkdir -p "$parent"

  if [[ -L "$link_path" ]]; then
    current="$(readlink "$link_path")"
    if [[ "$current" == "$target_abs" ]]; then
      ok "$link_path (already linked)"
      return 0
    fi
    if [[ -d "$current" ]]; then
      current_abs="$(cd "$current" && pwd)"
      if [[ "$current_abs" == "$target_abs" ]]; then
        ok "$link_path (already linked)"
        return 0
      fi
    fi
    step "Replacing symlink $link_path"
    rm "$link_path"
  elif [[ -e "$link_path" ]]; then
    fail "$link_path exists and is not a symlink. Remove or rename it, then re-run scripts/setup-macos-linux.sh"
  fi

  ln -sfn "$target_abs" "$link_path"
  ok "$link_path -> $target_abs"
}

install_tool_mirrors() {
  local install_root="$1" label="${2:-}"
  local prefix=""
  [[ -n "$label" ]] && prefix="[$label] "
  step "${prefix}${install_root}"

  link_to_target "$install_root/.cursor/skills" "$SKILLS_CANONICAL"
  link_to_target "$install_root/.cursor/rules" "$RULES_CANONICAL"
  link_to_target "$install_root/.claude/skills" "$SKILLS_CANONICAL"
  link_to_target "$install_root/.claude/rules" "$RULES_CANONICAL"
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

initialize_daily_issue_file() {
  local today issue_path template_path
  today="$(date +%Y-%m-%d)"
  issue_path="$REPO_ROOT/vault/issues/$today.md"
  if [[ -f "$issue_path" ]]; then
    ok "vault/issues/$today.md"
    return 0
  fi
  template_path="$REPO_ROOT/templates/template.issue.md"
  if [[ -f "$template_path" ]]; then
    sed -e "s/{{YYYY-MM-DD}}/$today/g" "$template_path" \
      | sed '/^## {{n}}\. {{title}}/,$d' > "$issue_path"
  else
    cat > "$issue_path" <<EOF
---
date: $today
tags: [issues]
---

# Issues — $today

<!-- Type: issues. See vault/README.md -->
EOF
  fi
  ok "created vault/issues/$today.md (daily issues bootstrap)"
}

install_vault_mirror() {
  local install_root="$1"
  if [[ "$install_root" == "$REPO_ROOT" ]]; then
    return 0
  fi
  link_to_target "$install_root/vault" "$REPO_ROOT/vault"
}

write_vault_pointer() {
  local install_root="$1"
  local pointer_dir="$install_root/.cursor"
  mkdir -p "$pointer_dir"
  cat > "$pointer_dir/ai-skills-vault.json" <<EOF
{
  "repoRoot": "$REPO_ROOT",
  "vaultRoot": "$REPO_ROOT/vault",
  "issuesRelative": "vault/issues",
  "learningsRelative": "vault/learnings"
}
EOF
  ok "wrote $pointer_dir/ai-skills-vault.json"
}

detect_multi_project_parent() {
  local parent entry name sibling_count=0
  parent="$(cd "$REPO_ROOT/.." && pwd)"
  [[ "$parent" != "$REPO_ROOT" ]] || return 1

  for marker in web api frontend backend; do
    [[ -d "$parent/$marker" ]] && { printf '%s' "$parent"; return 0; }
  done

  for entry in "$parent"/*; do
    [[ -d "$entry" ]] || continue
    name="$(basename "$entry")"
    [[ "$name" == .* ]] && continue
    [[ "$(cd "$entry" && pwd)" == "$REPO_ROOT" ]] && continue
    sibling_count=$((sibling_count + 1))
  done
  if [[ "$sibling_count" -ge 1 ]]; then
    printf '%s' "$parent"
    return 0
  fi
  return 1
}

test_vault_pointer() {
  local install_root="$1" label="${2:-}"
  [[ -f "$install_root/.cursor/ai-skills-vault.json" ]] \
    || fail "Verify failed ($label): missing $install_root/.cursor/ai-skills-vault.json"
  ok "$label ai-skills-vault.json"
}

test_vault_ready() {
  local install_root="$1" label="${2:-workspace}"
  local today issue_repo issue_ws
  today="$(date +%Y-%m-%d)"
  issue_repo="$REPO_ROOT/vault/issues/$today.md"
  [[ -f "$issue_repo" ]] || fail "Verify failed ($label): missing $issue_repo"
  if [[ "$install_root" != "$REPO_ROOT" ]]; then
    [[ -L "$install_root/vault" ]] || fail "Verify failed ($label): $install_root/vault must be symlink to repo vault"
    issue_ws="$install_root/vault/issues/$today.md"
    [[ -f "$issue_ws" ]] || fail "Verify failed ($label): workspace cannot read $issue_ws"
  fi
  ok "$label vault/issues/$today.md ready"
}

test_mirror_links() {
  local install_root="$1" label="${2:-workspace}"
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
    [[ -f "$install_root/$path" ]] || fail "Verify failed ($label / $name): missing $install_root/$path"
  done
  ok "$label mirror links resolve"
}

resolve_install_root() {
  if [[ -n "$WORKSPACE_ROOT" ]]; then
    local custom
    custom="$(cd "$WORKSPACE_ROOT" && pwd)"
    if [[ "$REPO_ONLY" == "1" || "$custom" == "$REPO_ROOT" ]]; then
      printf '%s|repo\n' "$REPO_ROOT"
      return 0
    fi
    printf '%s|workspace\n' "$custom"
    return 0
  fi

  if [[ "$REPO_ONLY" == "1" ]]; then
    printf '%s|repo\n' "$REPO_ROOT"
    return 0
  fi

  local auto_parent
  auto_parent="$(detect_multi_project_parent || true)"
  if [[ -n "$auto_parent" ]]; then
    printf '%s|workspace\n' "$auto_parent"
    return 0
  fi

  printf '%s|repo\n' "$REPO_ROOT"
}

remove_in_repo_mirrors() {
  local rel path current current_abs expected
  for rel in .cursor/skills .cursor/rules .claude/skills .claude/rules; do
    path="$REPO_ROOT/$rel"
    [[ -L "$path" ]] || continue
    current="$(readlink "$path")"
    if [[ "$rel" == *skills ]]; then expected="$SKILLS_CANONICAL"; else expected="$RULES_CANONICAL"; fi
    if [[ "$current" == "$expected" ]]; then
      rm "$path"
      ok "removed in-repo mirror $rel (use parent workspace links)"
      continue
    fi
    if [[ -d "$current" ]]; then
      current_abs="$(cd "$current" && pwd)"
      if [[ "$current_abs" == "$expected" ]]; then
        rm "$path"
        ok "removed in-repo mirror $rel (use parent workspace links)"
      fi
    fi
  done
}

INSTALL_LINE="$(resolve_install_root)"
INSTALL_ROOT="${INSTALL_LINE%|*}"
INSTALL_LABEL="${INSTALL_LINE#*|}"

printf '\nAI-SKILLS setup-macos-linux (symlinks)\n'
printf 'Repo: %s\n' "$REPO_ROOT"

step "Checking repo layout"
test_repo_layout

if [[ "$INSTALL_LABEL" == "workspace" ]]; then
  if [[ -n "$WORKSPACE_ROOT" ]]; then
    printf 'Cursor workspace (WORKSPACE_ROOT): %s\n' "$INSTALL_ROOT"
  else
    printf 'Cursor workspace (auto: sibling projects detected): %s\n' "$INSTALL_ROOT"
  fi
  printf 'Creating .cursor, .claude, vault symlink, ai-skills-vault.json here.\n\n'
fi

step "Creating Cursor / Claude symlinks"
install_tool_mirrors "$INSTALL_ROOT" "$INSTALL_LABEL"

if [[ "$INSTALL_LABEL" == "workspace" ]]; then
  step "Cleaning in-repo mirrors (optional)"
  remove_in_repo_mirrors
fi

step "Ensuring vault (folders, daily issues, workspace link)"
ensure_vault_folders
initialize_daily_issue_file
if [[ "$INSTALL_LABEL" == "workspace" ]]; then
  install_vault_mirror "$INSTALL_ROOT"
fi

write_vault_pointer "$REPO_ROOT"
if [[ "$INSTALL_LABEL" == "workspace" ]]; then
  write_vault_pointer "$INSTALL_ROOT"
fi

step "Verifying links"
test_mirror_links "$INSTALL_ROOT" "$INSTALL_LABEL"
test_vault_ready "$INSTALL_ROOT" "$INSTALL_LABEL"
test_vault_pointer "$REPO_ROOT" "repo"
if [[ "$INSTALL_LABEL" == "workspace" ]]; then
  test_vault_pointer "$INSTALL_ROOT" "$INSTALL_LABEL"
fi

printf '\nDone.\n'
printf 'Open in Cursor: %s\n' "$INSTALL_ROOT"
printf 'Then reload the window and try @ui-builder / @git-push.\n'
printf 'Obsidian: open repo root (%s) as vault — see vault/README.md.\n\n' "$REPO_ROOT"
