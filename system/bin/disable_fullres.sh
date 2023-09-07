#!/system/bin/sh

MODDIR=

error() {
  printf "An error has occurred. Please reboot.\n"
  exit 1
}

if grep -q "enabled" "$MODDIR/tmp/fullres_status.txt"; then
  rm "$MODDIR/tmp/fullres_status.txt" || error
  FAILED=0
  stop media || error
  cp "$MODDIR/tmp/fullres_disabled.txt" "$MODDIR/system/vendor/etc/camera/camxoverridesettings.txt" || FAILED=1
  sleep 1
  start media || error
  sleep 1
  if [[ $FAILED == 1 ]]; then error; fi
  killall -1 android.hardware.camera.provider@2.4-service_64 || error
  pm trim-caches 9999999999999 || error
  printf "disabled" > "$MODDIR/tmp/fullres_status.txt" || error
  printf "Full resolution is now disabled.\n"
  exit 0
elif grep -q "disabled" "$MODDIR/tmp/fullres_status.txt"; then
  printf "Full resolution is already disabled.\n"
  exit 0
else
  error
fi
