# OnePlus 9 Series Camera Unlocker

Magisk module that unlocks AUX cameras, face detection, and full resolution (48MP main and 50MP ultrawide) RAW on the OnePlus 9 series. Should work on all versions of OOS and any custom ROMs using OOS vendor FW. Full resolution only works in GCAM. Stock camera appears to still work.

**IMPORTANT: This module includes the functionality of my (sean6541) "OnePlus 9 (Pro) Aux Cameras Enabler" and "OnePlus 9 Series Full Resolution Unlocker" modules along with shadowstep's "OnePlus 9 & 9 Pro Camera Unlocker" module. YOU MUST UNINSTALL THESE MODULES OR THEY WILL CONFLICT AND IT MAY NOT WORK CORRECTLY!**


## IMPORTANT: How To Use It

1. Download latest op9_series_camera_unlocker.zip from releases page: [https://github.com/sean6541/op9_series_camera_unlocker/releases](https://github.com/sean6541/op9_series_camera_unlocker/releases)
2. Go to Magisk Manager -> Modules and click on "Install from storage". Choose Downloads/op9_series_camera_unlocker.zip
3. Reboot. Note that after any reboot, full resolution is disabled. AUX cameras and face detection are always unlocked.
4. If you want to use full resolution, download and install my custom app: [FullResToggle.apk](https://github.com/sean6541/op9_series_camera_unlocker/releases/download/v2.0/FullResToggle.apk). This app will not show up anywhere, all it does is create a quick settings tile labeled "Full Resolution". Add this new tile to your quick settings. Tap it to enable/disable full resolution. Wait approximately 10 seconds after toggling it before opening any camera apps. You will also need a GCAM and XML that are tuned for full resolution. You can find some listed below under [GCAMs And XMLs Compatible With Full Resolution](#gcams-and-xmls-compatible-with-full-resolution).

Why do we have to enable and disable full resolution? Because the only way to get it working is to force the camera sensors to output the full resolution stream. This means that third party camera (and camcorder) apps are also getting the full resolution stream, which is filled with noise and artifacts that only a properly tuned GCAM can eliminate. The front camera also doesn't work and video is limited to 30fps when full resolution is enabled.


## GCAMs And XMLs Compatible With Full Resolution

- Hasli's LMC 8.4: [https://www.celsoazevedo.com/files/android/google-camera/dev-hasli/f/dl11](https://www.celsoazevedo.com/files/android/google-camera/dev-hasli/f/dl11) with my test XML based on Arcide's LMC 8.4 v7.1: [LMC_48MP.xml](https://github.com/sean6541/op9_series_camera_unlocker/releases/download/v2.0/LMC_48MP.xml)


## For Developers And Advanced Users

You can enable, disable, and check the status of full resolution by entering the following into a terminal:
- `su -c enable_fullres.sh` to enable full resolution. Wait approximately 10 seconds before opening any camera apps.
- `su -c disable_fullres.sh` to disable full resolution. Wait approximately 10 seconds before opening any camera apps.
- `su -c fullres_status.sh` to check whether full resolution is enabled or disabled. Exit code `200` indicates that it is enabled while exit code `201` indicates disabled.
