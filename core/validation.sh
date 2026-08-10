#!/usr/bin/env bash
# core/validation.sh
# Input validation helpers used by commands.
#
# This file must be sourced, not executed.

if [[ -n "${ARCHFORGE_VALIDATION_LOADED:-}" ]]; then
  return 0
fi
ARCHFORGE_VALIDATION_LOADED=1

# validate_project_name <name>
#
# Returns 0 if the name is safe to use as a directory name, 1 otherwise.
# Rejects empty strings, ".", "..", "/", absolute/relative path components,
# and characters that are not safe for a directory name.
validate_project_name() {
  local name="${1:-}"

  if [[ -z "${name}" ]]; then
    error "project name cannot be empty."
    return 1
  fi

  if [[ "${name}" == "." || "${name}" == ".." ]]; then
    error "project name cannot be '.' or '..'."
    return 1
  fi

  # Reject any path separator to prevent path traversal (e.g. "../foo",
  # "a/b", or a bare "/").
  if [[ "${name}" == *"/"* ]]; then
    error "project name cannot contain '/'."
    return 1
  fi

  # Only allow a conservative, portable character set: letters, digits,
  # dash, and underscore. This intentionally rejects spaces, quotes,
  # shell metacharacters, and leading dashes (which could be confused
  # with command flags).
  if [[ ! "${name}" =~ ^[A-Za-z0-9][A-Za-z0-9_-]*$ ]]; then
    error "project name '${name}' contains invalid characters."
    error "Allowed: letters, digits, '-', '_' (must start with a letter or digit)."
    return 1
  fi

  return 0
}

# validate_architecture_exists <architecture-name>
#
# Returns 0 if templates/<architecture-name> exists and contains the
# expected metadata file, 1 otherwise.
validate_architecture_exists() {
  local arch="${1:-}"
  local template_dir="${ARCHFORGE_TEMPLATES_DIR}/${arch}"

  if [[ -z "${arch}" ]]; then
    error "architecture name cannot be empty."
    return 1
  fi

  if [[ ! -d "${template_dir}" ]]; then
    return 1
  fi

  if [[ ! -f "${template_dir}/${ARCHFORGE_TEMPLATE_METADATA_FILE}" ]]; then
    return 1
  fi

  return 0
}

# validate_target_directory_available <path>
#
# Returns 0 if the target directory does not already exist, 1 otherwise.
validate_target_directory_available() {
  local target="${1:-}"

  if [[ -e "${target}" ]]; then
    return 1
  fi

  return 0
}
