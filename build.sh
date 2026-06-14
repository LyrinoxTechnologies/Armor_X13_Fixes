#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x \
  "${ROOT_DIR}/customize.sh" \
  "${ROOT_DIR}/service.sh" \
  "${ROOT_DIR}/post-fs-data.sh" \
  "${ROOT_DIR}/collect-boot-audit.sh" \
  "${ROOT_DIR}/scripts/package.sh"

"${ROOT_DIR}/scripts/package.sh"