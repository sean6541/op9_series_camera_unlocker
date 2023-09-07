#!/system/bin/sh

MODDIR=

if grep -q "enabled" "$MODDIR/tmp/fullres_status.txt"; then
  printf "Full resolution is currently enabled.\n"
  exit 200
elif grep -q "disabled" "$MODDIR/tmp/fullres_status.txt"; then
  printf "Full resolution is currently disabled.\n"
  exit 201
else
  printf "An error has occurred. Please reboot.\n"
  exit 1
fi
