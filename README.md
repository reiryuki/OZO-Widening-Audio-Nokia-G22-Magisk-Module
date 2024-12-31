# OZO Widening Audio Nokia G22 Magisk Module

## DISCLAIMER
- Nokia blobs are owned by Nokia™.
- The MIT license specified here is for the Magisk Module only, not for Nokia blobs.

## Descriptions
- Post process type sound effect ported from Nokia G22 (SFI) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- No user interface activity

## Sources
- https://dumps.tadiphone.dev/dumps/nokia/sfi ussi_sunfire_full-user-14-UP1A.231005.007-eng.jenkin.20240717.151552-release-keys
- libmagiskpolicy.so: Kitsune Mask R6687BB53

## Screenshots
- https://t.me/ryukimodsscreenshots/37

## Requirements
- arm64-v8a or armeabi-v7a architecture
- Magisk or KernelSU or Kitsune Mask or Apatch or something similar installed

## Installation Guide & Download Link
- Install this module https://www.pling.com/p// via Magisk app or KernelSU app or Recovery if Magisk installed
- Install AML Magisk Module https://t.me/androidryukimodsdiscussions/29836 only if using any other else audio mod module
- Reboot
- You can boost internal speaker sound by running this command in Termux:

  `su`

  `resetprop persist.audio.sys.boostmode 1`

  To turn it off:

  `su`

  `resetprop persist.audio.sys.boostmode 0`

  Or:
  
  `su`

  `resetprop -p --delete persist.audio.sys.boostmode`


## Optionals
- https://t.me/ryukinotes/50
- Global: https://t.me/ryukinotes/35
- Stream: https://t.me/androidryukimodsdiscussions/26764

## Troubleshootings
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/androidryukimodsdiscussions/2618
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/ryukinotes/25


