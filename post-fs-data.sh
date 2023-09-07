MODDIR="${0%/*}"

enable_aux() {
  "$MODDIR/assets/jq" 'setpath(["default", "privileged_app_list"]; [""])' /odm/etc/camera/fwk_config.json > "$MODDIR/tmp/fwk_config.json" || return 0
  chcon u:object_r:vendor_configs_file:s0 "$MODDIR/tmp/fwk_config.json" || return 0
  mount --bind "$MODDIR/tmp/fwk_config.json" /odm/etc/camera/fwk_config.json || return 0
}

reset_camx_setting() {
  if grep -q -E -i "^[[:blank:]]*$1[[:blank:]]*=" "$MODDIR/tmp/fullres_enabled.txt"; then
    sed -i -r "s/^[[:blank:]]*$1[[:blank:]]*=.*/$1=$2/gI" "$MODDIR/tmp/fullres_enabled.txt" || return 1
  else
    printf "\n$1=$2\n" >> "$MODDIR/tmp/fullres_enabled.txt" || return 1
  fi
}

if [[ -d "$MODDIR/tmp" ]]; then rm -r "$MODDIR/tmp" || exit 1; fi
mkdir "$MODDIR/tmp" || exit 1
enable_aux

if [[ -d "$MODDIR/system/vendor" ]]; then rm -r "$MODDIR/system/vendor" || exit 1; fi
mkdir -p "$MODDIR/system/vendor/lib64/hw" || exit 1
"$MODDIR/assets/bbe" -e "s/com.oem.autotest/\x00om.oem.autotest/" -o "$MODDIR/system/vendor/lib64/hw/com.qti.chi.override.so" /vendor/lib64/hw/com.qti.chi.override.so || exit 1

mkdir -p "$MODDIR/system/vendor/etc/camera" || exit 1
sed -i -r "s,^MODDIR=.*,MODDIR=\"$MODDIR\",g" "$MODDIR/system/bin/disable_fullres.sh" || exit 1
sed -i -r "s,^MODDIR=.*,MODDIR=\"$MODDIR\",g" "$MODDIR/system/bin/enable_fullres.sh" || exit 1
sed -i -r "s,^MODDIR=.*,MODDIR=\"$MODDIR\",g" "$MODDIR/system/bin/fullres_status.sh" || exit 1
if [[ -f "/vendor/etc/camera/camxoverridesettings.txt" ]]; then
  cp /vendor/etc/camera/camxoverridesettings.txt "$MODDIR/tmp/fullres_disabled.txt" || exit 1
  cp "$MODDIR/tmp/fullres_disabled.txt" "$MODDIR/tmp/fullres_enabled.txt" || exit 1
  reset_camx_setting "overrideForceSensorMode" "0" || exit 1
  reset_camx_setting "exposeFullSizeForQCFA" "TRUE" || exit 1
  reset_camx_setting "useFeatureForQCFA" "0" || exit 1
else
  touch "$MODDIR/tmp/fullres_disabled.txt" || exit 1
  printf "overrideForceSensorMode=0\nexposeFullSizeForQCFA=TRUE\nuseFeatureForQCFA=0\n" > "$MODDIR/tmp/fullres_enabled.txt" || exit 1
fi
cp "$MODDIR/tmp/fullres_disabled.txt" "$MODDIR/system/vendor/etc/camera/camxoverridesettings.txt" || exit 1
chcon u:object_r:vendor_configs_file:s0 "$MODDIR/system/vendor/etc/camera/camxoverridesettings.txt" || exit 1
printf "disabled" > "$MODDIR/tmp/fullres_status.txt" || exit 1
