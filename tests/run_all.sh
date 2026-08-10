#!/usr/bin/env bash
# tests/run_all.sh
# Runs every tests/test_*.sh file and reports an aggregate result.
set -uo pipefail

SCRIPT_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

overall_status=0

for test_file in "${SCRIPT_DIR}"/test_*.sh; do
  [[ -f "${test_file}" ]] || continue
  printf '\n==> Running %s\n' "$(basename -- "${test_file}")"
  if ! bash "${test_file}"; then
    overall_status=1
  fi
done

if [[ "${overall_status}" -eq 0 ]]; then
  printf '\nAll test suites passed.\n'
else
  printf '\nOne or more test suites failed.\n'
fi

exit "${overall_status}"
