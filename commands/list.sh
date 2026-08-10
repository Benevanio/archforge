#!/usr/bin/env bash
# commands/list.sh
# Implements: archforge list
#
# This file must be sourced by bin/archforge, not executed directly.

cmd_list() {
  local -a architectures=()
  local line

  while IFS= read -r line; do
    [[ -n "${line}" ]] && architectures+=("${line}")
  done < <(list_architectures)

  if [[ "${#architectures[@]}" -eq 0 ]]; then
    warning "no architectures found in '${ARCHFORGE_TEMPLATES_DIR}'."
    return "${EXIT_SUCCESS}"
  fi

  printf 'Available architectures:\n\n'
  local arch
  for arch in "${architectures[@]}"; do
    printf '  %s\n' "${arch}"
  done

  return "${EXIT_SUCCESS}"
}
