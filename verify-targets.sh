#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPLACE_TARGETS=(
  "system/app/MyGene"
  "system/priv-app/PriSmartTouch"
  "system/product/app/UotaApp"
  "system/app/PriCloudList"
  "system/priv-app/PriChargingAni"
  "system/app/PriScreenOffKiller"
  "system/app/PriPedometer"
  "system/app/PriPermissionController"
  "system/app/PriSysResMon"
  "system/priv-app/PriFactoryTest"
  "system/app/PriFeatureX"
  "system/app/PriTheftProtection"
  "system/app/PriPowerSaveModeLauncher"
  "system/app/PriDynamicWindow"
  "system/app/PriGameSpace"
  "system/app/PriApplock"
  "system/app/PriStoreMode"
  "system/app/PriChildrenSpace"
  "system/app/PriBgVideo"
  "system/app/PriIceBox"
  "system/app/PriAiTextHelper"
  "system/app/PriAITexHelper"
  "system/priv-app/PriSecurityCenter"
  "system/priv-app/PriCleanLib"
  "system/priv-app/ServiceCenter"
  "system/priv-app/ServiceCenterSystem"
)

DISABLE_TARGETS=(
  com.pri.smart
  com.pri.smartfloatball
  com.pri.sysresmon
  com.gotron.uota
  com.dobest.dynamic
  com.dobest.securitycenter
  com.dobest.onekeyclean
  com.dobest.cleanlib
  com.dobest.search
  com.dobest.themecenter
  com.pri.cloudlist
  com.pri.screenoff.killer
  com.pri.pedometer
  com.pri.charginganimation
  com.pri.recordai
  com.pri.icebox
  com.pri.applock
  com.pri.gamespace
  com.pri.storemode
  com.pri.aitext
  com.pri.dynamicwindow
  com.pri.smartfloatball
  com.pri.powersavemodelauncher
  com.pri.bgvideo
  com.pri.childrenspace
  com.pri.factorytest
  com.pri.schpwronoff
  com.mediatek.duraspeed
  com.mediatek.engineermode
  com.google.android.setupwizard
)

missing_replace_targets=()
for target in "${REPLACE_TARGETS[@]}"; do
	if [ ! -e "${ROOT_DIR}/${target}/.replace" ]; then
		missing_replace_targets+=("${target}")
	fi
done

echo "Missing .replace paths:"
if [ "${#missing_replace_targets[@]}" -eq 0 ]; then
	echo "  none"
else
	for target in "${missing_replace_targets[@]}"; do
		echo "  ${target}"
	done
fi

echo
echo "Packages in disable list:"
for pkg in "${DISABLE_TARGETS[@]}"; do
	echo "  ${pkg}"
done

echo
echo "Packages still enabled:"
enabled_packages="$(adb shell pm list packages -e 2>/dev/null | tr -d '\r' || true)"
for pkg in "${DISABLE_TARGETS[@]}"; do
	if printf '%s\n' "$enabled_packages" | grep -q "^package:${pkg}$"; then
		echo "  ${pkg}"
	fi
done

echo
echo "Packages still running:"
running_packages="$(adb shell ps -A 2>/dev/null | tr -d '\r' || true)"
for pkg in "${DISABLE_TARGETS[@]}"; do
	if printf '%s\n' "$running_packages" | grep -qi "$pkg"; then
		echo "  ${pkg}"
	fi
done

echo
echo "pri|dobest|gotron|dura|sysresmon processes still alive:"
adb shell ps -A 2>/dev/null | tr -d '\r' | grep -Ei 'pri|dobest|gotron|dura|sysresmon' || echo "  none"