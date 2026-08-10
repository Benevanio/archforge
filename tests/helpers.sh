#!/usr/bin/env bash
# tests/helpers.sh
# Shared helpers for ArchForge's Bash test suite.
#
# This file must be sourced by test scripts, not executed directly.

TESTS_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck disable=SC2034 # used by test_*.sh files that source this helper
ARCHFORGE_BIN="${TESTS_DIR}/../bin/archforge"

TESTS_RUN=0
TESTS_FAILED=0

# A temporary sandbox directory tests can create projects in. Each test
# file gets its own subdirectory, cleaned up on exit.
setup_sandbox() {
  SANDBOX_DIR="$(mktemp -d)"
  export SANDBOX_DIR
}

teardown_sandbox() {
  if [[ -n "${SANDBOX_DIR:-}" && -d "${SANDBOX_DIR}" ]]; then
    rm -rf -- "${SANDBOX_DIR}"
  fi
}

# assert_equal <expected> <actual> <message>
assert_equal() {
  local expected="$1"
  local actual="$2"
  local message="${3:-values should be equal}"

  TESTS_RUN=$((TESTS_RUN + 1))

  if [[ "${expected}" != "${actual}" ]]; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf 'FAIL: %s\n  expected: %q\n  actual:   %q\n' "${message}" "${expected}" "${actual}"
    return 1
  fi

  printf 'PASS: %s\n' "${message}"
  return 0
}

# assert_contains <haystack> <needle> <message>
assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-output should contain expected text}"

  TESTS_RUN=$((TESTS_RUN + 1))

  if [[ "${haystack}" != *"${needle}"* ]]; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf 'FAIL: %s\n  expected to find: %q\n  in:               %q\n' "${message}" "${needle}" "${haystack}"
    return 1
  fi

  printf 'PASS: %s\n' "${message}"
  return 0
}

# assert_exit_code <expected> <actual> <message>
assert_exit_code() {
  local expected="$1"
  local actual="$2"
  local message="${3:-exit code should match}"
  assert_equal "${expected}" "${actual}" "${message}"
}

# assert_dir_exists <path> <message>
assert_dir_exists() {
  local path="$1"
  local message="${2:-directory should exist: ${path}}"

  TESTS_RUN=$((TESTS_RUN + 1))

  if [[ ! -d "${path}" ]]; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf 'FAIL: %s\n' "${message}"
    return 1
  fi

  printf 'PASS: %s\n' "${message}"
  return 0
}

# assert_file_not_exists <path> <message>
assert_file_not_exists() {
  local path="$1"
  local message="${2:-file should not exist: ${path}}"

  TESTS_RUN=$((TESTS_RUN + 1))

  if [[ -e "${path}" ]]; then
    TESTS_FAILED=$((TESTS_FAILED + 1))
    printf 'FAIL: %s\n' "${message}"
    return 1
  fi

  printf 'PASS: %s\n' "${message}"
  return 0
}

# report_results
#
# Prints a summary and exits non-zero if any assertion failed.
report_results() {
  printf '\n%d run, %d failed\n' "${TESTS_RUN}" "${TESTS_FAILED}"
  if [[ "${TESTS_FAILED}" -gt 0 ]]; then
    exit 1
  fi
  exit 0
}
