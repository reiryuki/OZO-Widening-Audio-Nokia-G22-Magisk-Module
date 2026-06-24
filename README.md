# OZO Widening Audio Nokia G22 Magisk Module

## DISCLAIMER
- Nokia blobs are owned by Nokia™.
- The MIT license specified here is for the Magisk Module only, not for Nokia blobs.

## Descriptions
- Post process type sound effect ported from Nokia G22 (SFI) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Boost loudspeaker audio only

## Sources
- https://dumps.tadiphone.dev/dumps/nokia/sfi ussi_sunfire_full-user-14-UP1A.231005.007-eng.jenkin.20240717.151552-release-keys
- libmagiskpolicy.so: Magisk (stable) 30.7 (30700)

## Changelog

v0.7
- Add UI ON/OFF toggler
- Support NoMount metamodule
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/
- Removes conflicted weird modules
- Does not disable raw playback (You can use Audio Compatibility Patch Reborn Magisk Module instead)

v0.6
- Fix wrong target in latest KernelSU
- Improve detections

v0.5
- Tidy up aml.sh
- Exclude \*audio\*effects\*haptic\*.xml
- Abort installation if fail to mount mirror system
- Fix wrong file permissions in some ROMs

v0.4
- Improve /odm and /my_product support detection

v0.3
- Fix script bugs which causes bootloop

v0.2
- Fix architecture detection in some weird ROMs
- Fix bug in uninstall.sh

v0.1
- Initial release

## Screenshots
- https://t.me/ryukimodsscreenshots/120
- https://t.me/ryukimodsscreenshots/37

## Requirements
- arm64-v8a or armeabi-v7a architecture
- HIDL audio service
- Magisk or KernelSU or Kitsune Mask or Apatch or something similar installed

## Installation Guide & Download Link
- Install this module via Magisk app or Kitsune Mask app or KernelSU app or Apatch app or Recovery if Magisk or Kitsune Mask installed
- Install AML Magisk Module https://t.me/androidryukimodsdiscussions/29836 only if using any other else audio mod module
- Reboot
- Open OZO Widening Audio app, turn it ON and grant root permission
- You can also turns it ON via Termux/Terminal Emulator:

  `su -c resetprop persist.audio.sys.boostmode 1`

  To turn it OFF:

  `su -c resetprop persist.audio.sys.boostmode 0`

  Or:
  
  `su -c resetprop -p --delete persist.audio.sys.boostmode`


## Optionals
- https://t.me/ryukinotes/50
- Global: https://t.me/ryukinotes/35
- Stream: https://t.me/ryukinotes/52

## Troubleshootings
- https://t.me/ryukinotes/50
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


