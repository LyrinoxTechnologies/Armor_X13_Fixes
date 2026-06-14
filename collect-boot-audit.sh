#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date '+%F_%H-%M-%S')"
OUT_DIR="${BASE_DIR}/boot-audit/${STAMP}"

mkdir -p "${OUT_DIR}"

wait_for_lock_screen() {
  until adb get-state >/dev/null 2>&1; do
    sleep 2
  done

  until [[ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; do
    sleep 5
  done

  until adb shell dumpsys window policy 2>/dev/null | grep -qE 'mShowingLockscreen=true|isStatusBarKeyguard=true|Keyguard'; do
    sleep 5
  done
}

capture() {
  local output_file="$1"
  shift
  "$@" > "${OUT_DIR}/${output_file}"
}

wait_for_lock_screen

adb shell su -c 'dmesg > /sdcard/dmesg-after-boot.txt'
adb pull /sdcard/dmesg-after-boot.txt "${OUT_DIR}/dmesg-after-boot.txt"

capture logcat-after-boot.txt adb shell logcat -d -b all
capture activity-processes.txt adb shell dumpsys activity processes
capture activity-services.txt adb shell dumpsys activity services
capture jobscheduler.txt adb shell dumpsys jobscheduler
capture alarm.txt adb shell dumpsys alarm
capture batterystats.txt adb shell dumpsys batterystats
capture getprop.txt adb shell getprop
capture packages-disabled.txt adb shell cmd package list packages -d
capture packages-enabled.txt adb shell cmd package list packages -e

grep -E "boot|dexopt|dalvik|zygote|lmk|zram|log|thermal" "${OUT_DIR}/getprop.txt" > "${OUT_DIR}/getprop-filtered.txt" || true

echo "Boot audit saved to ${OUT_DIR}"