#!/usr/bin/env bash
# core/template.sh
# Template discovery and metadata loading.
#
# Templates are plain directories under templates/<name>/ that contain an
# archforge.conf metadata file. There is no hardcoded list of architectures
# anywhere in the CLI: everything is discovered from the filesystem.
#
# This file must be sourced, not executed.

if [[ -n "${ARCHFORGE_TEMPLATE_LOADED:-}" ]]; then
  return 0
fi
ARCHFORGE_TEMPLATE_LOADED=1

# list_architectures
#
# Prints one architecture name per line, sorted alphabetically. An
# architecture is any subdirectory of templates/ that contains an
# archforge.conf file.
list_architectures() {
  local dir
  local -a found=()

  if [[ ! -d "${ARCHFORGE_TEMPLATES_DIR}" ]]; then
    return 0
  fi

  for dir in "${ARCHFORGE_TEMPLATES_DIR}"/*/; do
    [[ -d "${dir}" ]] || continue
    local name
    name="$(basename -- "${dir}")"
    if [[ -f "${dir}${ARCHFORGE_TEMPLATE_METADATA_FILE}" ]]; then
      found+=("${name}")
    fi
  done

  if [[ "${#found[@]}" -eq 0 ]]; then
    return 0
  fi

  printf '%s\n' "${found[@]}" | sort
}

# load_template_metadata <architecture-name>
#
# Sources the architecture's archforge.conf file in a restricted subshell
# and prints its recognized fields as "KEY=value" lines, so callers can
# safely capture them without executing arbitrary code from the template
# in their own shell.
#
# Recognized fields: NAME, DESCRIPTION, VERSION, LAYERS, PRINCIPLES
load_template_metadata() {
  local arch="${1:?architecture name is required}"
  local conf_path="${ARCHFORGE_TEMPLATES_DIR}/${arch}/${ARCHFORGE_TEMPLATE_METADATA_FILE}"

  if [[ ! -f "${conf_path}" ]]; then
    error "metadata file not found for architecture '${arch}'."
    return 1
  fi

  # Run in a subshell so that variables set by the conf file (and nothing
  # else) never leak into the caller's environment, and so the conf file
  # cannot execute arbitrary commands that affect the parent process.
  (
    NAME=""
    DESCRIPTION=""
    VERSION=""
    LAYERS=""
    PRINCIPLES=""

    # shellcheck disable=SC1090
    source "${conf_path}"

    printf 'NAME=%s\n' "${NAME}"
    printf 'DESCRIPTION=%s\n' "${DESCRIPTION}"
    printf 'VERSION=%s\n' "${VERSION}"
    printf 'LAYERS=%s\n' "${LAYERS}"
    printf 'PRINCIPLES=%s\n' "${PRINCIPLES}"
  )
}
