#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
MODULE_NAME="LyrinoxOS-Debloat-ArmorX13"
VERSION="$(grep '^version=' "${ROOT_DIR}/module.prop" | cut -d= -f2-)"
ZIP_PATH="${DIST_DIR}/${MODULE_NAME}-${VERSION}.zip"

mkdir -p "${DIST_DIR}"
rm -f "${ZIP_PATH}"

FILES=(
  module.prop
  customize.sh
  service.sh
  post-fs-data.sh
  system.prop
  README.md
  boot-audit.md
  collect-boot-audit.sh
)

pushd "${ROOT_DIR}" >/dev/null
zip -r9 "${ZIP_PATH}" "${FILES[@]}" system
popd >/dev/null

echo "Created ${ZIP_PATH}"
