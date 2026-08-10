#!/usr/bin/env bash
# tests/test_info.sh
set -uo pipefail

SCRIPT_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=./helpers.sh
source "${SCRIPT_DIR}/helpers.sh"

output="$("${ARCHFORGE_BIN}" info clean-ddd)"
exit_code=$?

assert_exit_code 0 "${exit_code}" "'archforge info clean-ddd' should exit 0"
assert_contains "${output}" "Architecture: Clean Architecture + DDD" "output should show architecture name"
assert_contains "${output}" "Domain-centric architecture" "output should show description"
assert_contains "${output}" "domain" "output should list the domain layer"
assert_contains "${output}" "Dependency Inversion" "output should list a principle"

unknown_output="$("${ARCHFORGE_BIN}" info does-not-exist 2>&1)"
unknown_exit_code=$?

assert_exit_code 3 "${unknown_exit_code}" "'archforge info <unknown>' should exit with TEMPLATE_NOT_FOUND (3)"
assert_contains "${unknown_output}" "was not found" "output should explain the architecture was not found"

report_results
