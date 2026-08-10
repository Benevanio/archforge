#!/usr/bin/env bash
# install.sh
# Installs ArchForge by symlinking bin/archforge into a directory on PATH.
#
# This script is non-destructive: it never overwrites an existing file
# that isn't already a symlink to this project's bin/archforge, and it
# never modifies shell configuration files on your behalf.
set -euo pipefail

SCRIPT_DIR="$(cd -P "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SOURCE_BIN="${SCRIPT_DIR}/bin/archforge"

# ---------------------------------------------------------------------------
# 1. Detect operating system
# ---------------------------------------------------------------------------
OS_NAME="$(uname -s 2>/dev/null || echo unknown)"

case "${OS_NAME}" in
  Linux*)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      PLATFORM="WSL"
    else
      PLATFORM="Linux"
    fi
    ;;
  Darwin*)
    PLATFORM="macOS"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    PLATFORM="Windows (Git Bash)"
    ;;
  *)
    PLATFORM="unknown (${OS_NAME})"
    ;;
esac

echo "Detected platform: ${PLATFORM}"

# ---------------------------------------------------------------------------
# 2. Verify basic dependencies
# ---------------------------------------------------------------------------
if ! command -v bash >/dev/null 2>&1; then
  echo "Error: bash is required but was not found." >&2
  exit 1
fi

BASH_MAJOR_VERSION="${BASH_VERSINFO[0]:-0}"
if [[ "${BASH_MAJOR_VERSION}" -lt 4 ]]; then
  echo "Warning: ArchForge requires Bash 4+. Detected: ${BASH_VERSION:-unknown}." >&2
fi

if [[ ! -x "${SOURCE_BIN}" ]]; then
  echo "Error: '${SOURCE_BIN}' not found or not executable." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 3. Choose an install directory
# ---------------------------------------------------------------------------
# Prefer a user-writable directory to avoid requiring sudo. Fall back to
# /usr/local/bin (common on Linux/macOS) only if it is writable; otherwise
# default to ~/.local/bin, creating it if necessary.
INSTALL_DIR=""

if [[ -w "/usr/local/bin" ]]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="${HOME}/.local/bin"
  mkdir -p -- "${INSTALL_DIR}"
fi

TARGET="${INSTALL_DIR}/archforge"

# ---------------------------------------------------------------------------
# 4. Install (symlink), without being destructive
# ---------------------------------------------------------------------------
if [[ -e "${TARGET}" && ! -L "${TARGET}" ]]; then
  # Allow replacing files previously managed by this installer.
  if ! cmp -s -- "${TARGET}" "${SOURCE_BIN}" 2>/dev/null \
    && ! grep -q '^# ArchForge launcher wrapper$' "${TARGET}" 2>/dev/null; then
    echo "Error: '${TARGET}' already exists and is not a managed ArchForge install." >&2
    echo "Refusing to overwrite it. Remove it manually or choose a different" >&2
    echo "install location, then re-run this script." >&2
    exit 1
  fi
fi

ln -sf -- "${SOURCE_BIN}" "${TARGET}"

if [[ -L "${TARGET}" ]]; then
  echo "Installed: ${TARGET} -> ${SOURCE_BIN}"
else
  # Some Windows/Git Bash setups cannot create true symlinks without extra
  # privileges and end up creating a regular file instead.
  cat >"${TARGET}" <<EOF
#!/usr/bin/env bash
# ArchForge launcher wrapper
exec "${SOURCE_BIN}" "\$@"
EOF
  chmod +x -- "${TARGET}"
  echo "Installed launcher: ${TARGET} -> ${SOURCE_BIN}"
fi

# ---------------------------------------------------------------------------
# 5. Check PATH
# ---------------------------------------------------------------------------
case ":${PATH}:" in
  *":${INSTALL_DIR}:"*)
    echo "'${INSTALL_DIR}' is already on your PATH."
    echo ""
    echo "Run 'archforge --help' to get started."
    ;;
  *)
    echo ""
    echo "'${INSTALL_DIR}' is not on your PATH."
    echo "Add the following line to your shell profile (e.g. ~/.bashrc, ~/.zshrc):"
    echo ""
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    echo ""
    echo "Then restart your shell or run: source ~/.bashrc"
    ;;
esac
