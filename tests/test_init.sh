#!/usr/bin/env bash
# tests/test_init.sh
set -uo pipefail

SCRIPT_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=./helpers.sh
source "${SCRIPT_DIR}/helpers.sh"

setup_sandbox
trap teardown_sandbox EXIT

# ---------------------------------------------------------------------------
# Successful generation (clean-ddd)
# ---------------------------------------------------------------------------
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init test-project --arch clean-ddd >/tmp/archforge_init_stdout.$$ 2>&1
  echo $? > /tmp/archforge_init_exit.$$
)
init_exit_code="$(cat /tmp/archforge_init_exit.$$)"
rm -f /tmp/archforge_init_stdout.$$ /tmp/archforge_init_exit.$$

assert_exit_code 0 "${init_exit_code}" "'archforge init test-project --arch clean-ddd' should succeed"

assert_dir_exists "${SANDBOX_DIR}/test-project/src/domain" "domain layer should exist"
assert_dir_exists "${SANDBOX_DIR}/test-project/src/application" "application layer should exist"
assert_dir_exists "${SANDBOX_DIR}/test-project/src/infrastructure" "infrastructure layer should exist"
assert_dir_exists "${SANDBOX_DIR}/test-project/src/presentation" "presentation layer should exist"
assert_file_not_exists "${SANDBOX_DIR}/test-project/archforge.conf" "generated project should not contain ArchForge metadata"

# ---------------------------------------------------------------------------
# Unknown architecture
# ---------------------------------------------------------------------------
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init unknown-arch-project --arch does-not-exist >/tmp/archforge_unknown.$$ 2>&1
  echo $? > /tmp/archforge_unknown_exit.$$
)
unknown_exit_code="$(cat /tmp/archforge_unknown_exit.$$)"
rm -f /tmp/archforge_unknown.$$ /tmp/archforge_unknown_exit.$$

assert_exit_code 3 "${unknown_exit_code}" "init with an unknown architecture should exit with TEMPLATE_NOT_FOUND (3)"
assert_file_not_exists "${SANDBOX_DIR}/unknown-arch-project" "no directory should be created for an unknown architecture"

# ---------------------------------------------------------------------------
# Existing directory
# ---------------------------------------------------------------------------
mkdir -p "${SANDBOX_DIR}/existing-project"
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init existing-project --arch mvc >/tmp/archforge_existing.$$ 2>&1
  echo $? > /tmp/archforge_existing_exit.$$
)
existing_exit_code="$(cat /tmp/archforge_existing_exit.$$)"
rm -f /tmp/archforge_existing.$$ /tmp/archforge_existing_exit.$$

assert_exit_code 4 "${existing_exit_code}" "init into an existing directory should exit with PROJECT_EXISTS (4)"

# ---------------------------------------------------------------------------
# Invalid project names
# ---------------------------------------------------------------------------
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init ".." --arch mvc >/dev/null 2>&1
  echo $? > /tmp/archforge_dotdot_exit.$$
)
dotdot_exit_code="$(cat /tmp/archforge_dotdot_exit.$$)"
rm -f /tmp/archforge_dotdot_exit.$$
assert_exit_code 2 "${dotdot_exit_code}" "init with '..' as name should exit with INVALID_ARGUMENTS (2)"

(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init "../path-traversal" --arch mvc >/dev/null 2>&1
  echo $? > /tmp/archforge_traversal_exit.$$
)
traversal_exit_code="$(cat /tmp/archforge_traversal_exit.$$)"
rm -f /tmp/archforge_traversal_exit.$$
assert_exit_code 2 "${traversal_exit_code}" "init with a path-traversal name should exit with INVALID_ARGUMENTS (2)"

# ---------------------------------------------------------------------------
# Missing --arch
# ---------------------------------------------------------------------------
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init no-arch-project >/dev/null 2>&1
  echo $? > /tmp/archforge_noarch_exit.$$
)
noarch_exit_code="$(cat /tmp/archforge_noarch_exit.$$)"
rm -f /tmp/archforge_noarch_exit.$$
assert_exit_code 2 "${noarch_exit_code}" "init without --arch should exit with INVALID_ARGUMENTS (2)"

# ---------------------------------------------------------------------------
# mvc and mmvc generation
# ---------------------------------------------------------------------------
(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init mvc-project --arch mvc >/dev/null 2>&1
)
assert_dir_exists "${SANDBOX_DIR}/mvc-project/src/controllers" "mvc controllers layer should exist"
assert_dir_exists "${SANDBOX_DIR}/mvc-project/src/models" "mvc models layer should exist"

(
  cd "${SANDBOX_DIR}" || exit 1
  "${ARCHFORGE_BIN}" init mmvc-project --arch mmvc >/dev/null 2>&1
)
assert_dir_exists "${SANDBOX_DIR}/mmvc-project/src/view-models" "mmvc view-models layer should exist"

report_results
