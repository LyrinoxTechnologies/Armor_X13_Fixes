# Boot Audit

Use these commands to collect data after a slow boot or persistent-process issue:

```bash
adb shell su -c 'dmesg > /sdcard/dmesg-after-boot.txt'
adb pull /sdcard/dmesg-after-boot.txt

adb shell logcat -d -b all > logcat-after-boot.txt

adb shell dumpsys activity processes > activity-processes.txt
adb shell dumpsys activity services > activity-services.txt
adb shell dumpsys jobscheduler > jobscheduler.txt
adb shell dumpsys alarm > alarm.txt
adb shell dumpsys batterystats > batterystats.txt

adb shell getprop | grep -E "boot|dexopt|dalvik|zygote|lmk|zram|log|thermal"
adb shell cmd package list packages -d
adb shell cmd package list packages -e
```