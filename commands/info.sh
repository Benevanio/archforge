#!/usr/bin/env bash
# commands/info.sh
# Implements: archforge info <architecture>
#
# This file must be sourced by bin/archforge, not executed directly.

cmd_info() {
  local arch="${1:-}"

  if [[ -z "${arch}" ]]; then
    error "missing architecture name."
    printf '\nUsage:\n\n  archforge info <architecture>\n' >&2
    return "${EXIT_INVALID_ARGUMENTS}"
  fi

  if ! validate_architecture_exists "${arch}"; then
    error "architecture '${arch}' was not found."
    printf '\nRun:\n\n  archforge list\n' >&2
    return "${EXIT_TEMPLATE_NOT_FOUND}"
  fi

  local metadata
  if ! metadata="$(load_template_metadata "${arch}")"; then
    return "${EXIT_GENERAL_ERROR}"
  fi

  local name="" description="" version="" layers="" principles=""
  local key value
  while IFS='=' read -r key value; do
    case "${key}" in
      NAME) name="${value}" ;;
      DESCRIPTION) description="${value}" ;;
      VERSION) version="${value}" ;;
      LAYERS) layers="${value}" ;;
      PRINCIPLES) principles="${value}" ;;
    esac
  done <<< "${metadata}"

  [[ -z "${name}" ]] && name="${arch}"

  printf 'Architecture: %s\n' "${name}"

  if [[ -n "${description}" ]]; then
    printf '\nDescription:\n%s\n' "${description}"
  fi

  if [[ -n "${layers}" ]]; then
    printf '\nLayers:\n\n'
    local layer
    for layer in ${layers}; do
      printf '  %s\n' "${layer}"
    done
  fi

  if [[ -n "${principles}" ]]; then
    printf '\nPrinciples:\n\n'
    local principle
    while IFS= read -r principle; do
      [[ -n "${principle}" ]] && printf '  %s\n' "${principle}"
    done <<< "$(printf '%s' "${principles}" | tr ',' '\n')"
  fi

  if [[ -n "${version}" ]]; then
    printf '\nTemplate version: %s\n' "${version}"
  fi

  return "${EXIT_SUCCESS}"
}
