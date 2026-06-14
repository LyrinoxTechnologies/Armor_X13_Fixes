#!/system/bin/sh

LOG_FILE="/data/adb/lyrinoxos-debloat.log"

DISABLE_PKGS="
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
"

log() {
	echo "[$(date '+%F %T')] $1" >> "$LOG_FILE"
}

wait_for_boot_complete() {
	until [ "$(getprop sys.boot_completed)" = "1" ]; do
		sleep 5
	done
}

apply_setting() {
	namespace="$1"
	key="$2"
	value="$3"
	settings put "$namespace" "$key" "$value" >/dev/null 2>&1 || true
	log "settings put $namespace $key $value"
}

enforce_disabled_packages() {
	for pkg in $DISABLE_PKGS; do
		if pm path "$pkg" >/dev/null 2>&1; then
			if am force-stop "$pkg" >> "$LOG_FILE" 2>&1; then
				log "force-stopped: $pkg"
			else
				log "force-stop failed or protected: $pkg"
			fi
			if pm list packages -d 2>/dev/null | grep -q "^package:$pkg$"; then
				log "already disabled: $pkg"
			else
				pm disable-user --user 0 "$pkg" >> "$LOG_FILE" 2>&1 || true
				if pm list packages -d 2>/dev/null | grep -q "^package:$pkg$"; then
					log "disabled: $pkg"
				else
					log "disable attempt failed or protected: $pkg"
				fi
			fi
		else
			log "not installed: $pkg"
		fi
	done
}

reapply_activity_manager_constants() {
	current_constants="$(settings get global activity_manager_constants 2>/dev/null | tr -d '\r')"
	if [ -n "$current_constants" ] && [ "$current_constants" != "null" ]; then
		settings put global activity_manager_constants "$current_constants" >/dev/null 2>&1 || true
		log "settings put global activity_manager_constants $current_constants"
	else
		log "activity_manager_constants not set"
	fi
}

mkdir -p /data/adb
: > "$LOG_FILE"
log "service.sh started"

wait_for_boot_complete
log "boot completed"

enforce_disabled_packages

for svc in connsyslogger emdlogger mobile_log_d; do
	if stop "$svc" 2>/dev/null; then
		log "stop service succeeded: $svc"
	else
		log "stop service failed or not present: $svc"
	fi
done

apply_setting global window_animation_scale 0.5
apply_setting global transition_animation_scale 0.5
apply_setting global animator_duration_scale 0.5
reapply_activity_manager_constants
apply_setting global cached_apps_freezer enabled

log "service.sh finished"
