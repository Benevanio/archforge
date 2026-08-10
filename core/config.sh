#!/usr/bin/env bash
# core/config.sh
# Centralized configuration and constants for ArchForge.
#
# This file must be sourced, not executed.
#
# shellcheck disable=SC2034
# (Variables defined here are consumed by other sourced files -
# core/logger.sh, core/validation.sh, core/filesystem.sh, core/template.sh,
# commands/*.sh - which ShellCheck cannot see when this file is linted on
# its own.)

# Guard against multiple sourcing.
if [[ -n "${ARCHFORGE_CONFIG_LOADED:-}" ]]; then
  return 0
fi
ARCHFORGE_CONFIG_LOADED=1

# ---------------------------------------------------------------------------
# Version
# ---------------------------------------------------------------------------
ARCHFORGE_VERSION="0.1.0"

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
# ARCHFORGE_ROOT must be set by the entrypoint (bin/archforge) before this
# file is sourced. It points at the root of the installed/cloned project.
: "${ARCHFORGE_ROOT:?ARCHFORGE_ROOT must be set before sourcing config.sh}"

ARCHFORGE_COMMANDS_DIR="${ARCHFORGE_ROOT}/commands"
ARCHFORGE_CORE_DIR="${ARCHFORGE_ROOT}/core"
ARCHFORGE_TEMPLATES_DIR="${ARCHFORGE_ROOT}/templates"

# Name of the metadata file expected inside every template directory.
ARCHFORGE_TEMPLATE_METADATA_FILE="archforge.conf"

# ---------------------------------------------------------------------------
# Exit codes (see docs/architecture.md for the full table)
# ---------------------------------------------------------------------------
readonly EXIT_SUCCESS=0
readonly EXIT_GENERAL_ERROR=1
readonly EXIT_INVALID_ARGUMENTS=2
readonly EXIT_TEMPLATE_NOT_FOUND=3
readonly EXIT_PROJECT_EXISTS=4
