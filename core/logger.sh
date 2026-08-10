#!/usr/bin/env bash
# core/logger.sh
# Simple leveled logging with optional color support.
#
# This file must be sourced, not executed.

if [[ -n "${ARCHFORGE_LOGGER_LOADED:-}" ]]; then
  return 0
fi
ARCHFORGE_LOGGER_LOADED=1

# Only use colors when connected to an interactive terminal that supports
# them. Never make functionality depend on color being available.
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  ARCHFORGE_COLOR_RED="$(tput setaf 1)"
  ARCHFORGE_COLOR_GREEN="$(tput setaf 2)"
  ARCHFORGE_COLOR_YELLOW="$(tput setaf 3)"
  ARCHFORGE_COLOR_BLUE="$(tput setaf 4)"
  ARCHFORGE_COLOR_RESET="$(tput sgr0)"
else
  ARCHFORGE_COLOR_RED=""
  ARCHFORGE_COLOR_GREEN=""
  ARCHFORGE_COLOR_YELLOW=""
  ARCHFORGE_COLOR_BLUE=""
  ARCHFORGE_COLOR_RESET=""
fi

info() {
  printf '%s[INFO]%s %s\n' "${ARCHFORGE_COLOR_BLUE}" "${ARCHFORGE_COLOR_RESET}" "$*"
}

success() {
  printf '%s[SUCCESS]%s %s\n' "${ARCHFORGE_COLOR_GREEN}" "${ARCHFORGE_COLOR_RESET}" "$*"
}

warning() {
  printf '%s[WARNING]%s %s\n' "${ARCHFORGE_COLOR_YELLOW}" "${ARCHFORGE_COLOR_RESET}" "$*" >&2
}

error() {
  printf '%s[ERROR]%s %s\n' "${ARCHFORGE_COLOR_RED}" "${ARCHFORGE_COLOR_RESET}" "$*" >&2
}
