#!/usr/bin/env bash
# tests/test_list.sh
set -uo pipefail

SCRIPT_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=./helpers.sh
source "${SCRIPT_DIR}/helpers.sh"

output="$("${ARCHFORGE_BIN}" list)"
exit_code=$?

assert_exit_code 0 "${exit_code}" "'archforge list' should exit 0"
assert_contains "${output}" "Available architectures:" "output should have a header"
assert_contains "${output}" "clean-ddd" "output should list clean-ddd"
assert_contains "${output}" "mvc" "output should list mvc"
assert_contains "${output}" "mmvc" "output should list mmvc"

report_results
