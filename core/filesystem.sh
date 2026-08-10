#!/usr/bin/env bash
# core/filesystem.sh
# Safe filesystem operations used when generating projects from templates.
#
# This file must be sourced, not executed.

if [[ -n "${ARCHFORGE_FILESYSTEM_LOADED:-}" ]]; then
  return 0
fi
ARCHFORGE_FILESYSTEM_LOADED=1

# copy_template_to_project <template_dir> <target_dir>
#
# Copies the contents of <template_dir> into a new <target_dir>.
# Assumes both paths have already been validated by the caller
# (see core/validation.sh). Uses `cp -R` with explicit source/destination
# arguments (no globbing on user input) to avoid path traversal or
# unintended expansion.
copy_template_to_project() {
  local template_dir="${1:?template_dir is required}"
  local target_dir="${2:?target_dir is required}"

  if [[ ! -d "${template_dir}" ]]; then
    error "template directory '${template_dir}' does not exist."
    return 1
  fi

  if [[ -e "${target_dir}" ]]; then
    error "target directory '${target_dir}' already exists."
    return 1
  fi

  mkdir -p -- "${target_dir}"

  # Copy contents (not the template directory itself) into the target.
  # The trailing "/." ensures dotfiles (like .gitignore) are copied too.
  if ! cp -R -- "${template_dir}/." "${target_dir}/"; then
    error "failed to copy template contents to '${target_dir}'."
    return 1
  fi

  return 0
}

# remove_archforge_metadata <project_dir>
#
# Removes ArchForge-specific metadata files from a generated project so
# that the final output does not leak internal template bookkeeping.
remove_archforge_metadata() {
  local project_dir="${1:?project_dir is required}"

  if [[ ! -d "${project_dir}" ]]; then
    error "project directory '${project_dir}' does not exist."
    return 1
  fi

  local metadata_path="${project_dir}/${ARCHFORGE_TEMPLATE_METADATA_FILE}"
  if [[ -f "${metadata_path}" ]]; then
    rm -f -- "${metadata_path}"
  fi

  return 0
}
