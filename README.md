# LyrinoxOS-Debloat-ArmorX13

Magisk module for the Ulefone Armor X13 on Android 15 / MT6765, authored by LyrinoxTechnologies.

This project is fully open source under GPLv3 or later.

## Installation

1. Build the ZIP with `./build.sh`.
2. Flash the generated Magisk ZIP.
3. Reboot the device.
4. Check the log at `/data/adb/lyrinoxos-debloat.log` if anything looks off.

## Recovery

If the device bootloops or becomes unstable, remove the module from recovery or use Magisk safe mode, then reboot.

## Verification

Run these checks after boot:

```bash
adb shell pm list packages -d | grep -E "pri|dobest|gotron|dura|sysresmon"
adb shell ps -A | grep -E "pri|dobest|gotron|dura|sysresmon"
adb shell dumpsys activity processes | grep -iE "PERS|pri|dobest|gotron|dura|sysresmon"
adb shell su -c 'dumpsys meminfo | head -n 80'
adb shell cat /proc/swaps
```

## Module Contents

- `system/app/PriCloudList/.replace`
- `system/app/PriScreenOffKiller/.replace`
- `system/app/PriPedometer/.replace`
- `system/app/PriPermissionController/.replace`
- `system/app/MyGene/.replace`
- `system/priv-app/PriChargingAni/.replace`
- `system/product/app/UotaApp/.replace`
- `service.sh`: boot-complete hook, force-stop pass, animation tuning, freezer toggle, logging.
- `system.prop`: conservative log and tracing reductions only.

## Notes

This module intentionally does not disable Google apps or touch core telephony, camera, NFC, fingerprint, network, or Play Services components.
