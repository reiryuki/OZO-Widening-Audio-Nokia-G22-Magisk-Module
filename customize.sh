# space
ui_print " "

# var
UID=`id -u`
[ ! "$UID" ] && UID=0
FIRARCH=`grep_get_prop ro.bionic.arch`
SECARCH=`grep_get_prop ro.bionic.2nd_arch`
ABILIST=`grep_get_prop ro.product.cpu.abilist`
if [ ! "$ABILIST" ]; then
  ABILIST=`grep_get_prop ro.system.product.cpu.abilist`
fi
if [ "$FIRARCH" == arm64 ]\
&& ! echo "$ABILIST" | grep -q arm64-v8a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,arm64-v8a"
  else
    ABILIST=arm64-v8a
  fi
fi
if [ "$FIRARCH" == x64 ]\
&& ! echo "$ABILIST" | grep -q x86_64; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86_64"
  else
    ABILIST=x86_64
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi"
  else
    ABILIST=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi-v7a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi-v7a"
  else
    ABILIST=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST" | grep -q x86; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86"
  else
    ABILIST=x86
  fi
fi
ABILIST32=`grep_get_prop ro.product.cpu.abilist32`
if [ ! "$ABILIST32" ]; then
  ABILIST32=`grep_get_prop ro.system.product.cpu.abilist32`
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi"
  else
    ABILIST32=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi-v7a; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi-v7a"
  else
    ABILIST32=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST32" | grep -q x86; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,x86"
  else
    ABILIST32=x86
  fi
fi
if [ ! "$ABILIST32" ]; then
  [ -f /system/lib/libandroid.so ] && ABILIST32=true
fi

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/data/media/"$UID"/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# optionals
OPTIONALS=/data/media/"$UID"/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# debug
if [ "`grep_prop debug.log $OPTIONALS`" == 1 ]; then
  ui_print "- The install log will contain detailed information"
  set -x
  ui_print " "
fi

# recovery
if [ "$BOOTMODE" != true ]; then
  MODPATH_UPDATE=`echo $MODPATH | sed 's|modules/|modules_update/|g'`
  rm -f $MODPATH/update
  rm -rf $MODPATH_UPDATE
fi

# run
. $MODPATH/function.sh

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# architecture
if [ "$ABILIST" ]; then
  ui_print "- $ABILIST architecture"
  ui_print " "
fi
NAME=arm64-v8a
NAME2=armeabi-v7a
if ! echo "$ABILIST" | grep -q $NAME; then
  if echo "$ABILIST" | grep -q $NAME2; then
    rm -rf `find $MODPATH/system -type d -name *64*`
  else
    if [ "$BOOTMODE" == true ]; then
      ui_print "! This ROM doesn't support $NAME nor $NAME2 architecture"
    else
      ui_print "! This Recovery doesn't support $NAME nor $NAME2 architecture"
      ui_print "  Try to install via Magisk app instead"
    fi
    abort
  fi
fi
if ! echo "$ABILIST" | grep -q $NAME2; then
  rm -rf $MODPATH/system*/lib\
   $MODPATH/system*/vendor/lib
  if [ "$BOOTMODE" != true ]; then
    ui_print "! This Recovery doesn't support $NAME2 architecture"
    ui_print "  Try to install via Magisk app instead"
    ui_print " "
  fi
fi

# recovery
mount_partitions_in_recovery

# magisk
magisk_setup

# path
SYSTEM=`realpath $MIRROR/system`
VENDOR=`realpath $MIRROR/vendor`
PRODUCT=`realpath $MIRROR/product`
SYSTEM_EXT=`realpath $MIRROR/system_ext`
ODM=`realpath $MIRROR/odm`
MY_PRODUCT=`realpath $MIRROR/my_product`

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# cleaning
ui_print "- Cleaning..."
remove_sepolicy_rule
ui_print " "

# function
conflict() {
for NAME in $NAMES; do
  DIR=/data/adb/modules_update/$NAME
  if [ -f $DIR/uninstall.sh ]; then
    sh $DIR/uninstall.sh
  fi
  rm -rf $DIR
  DIR=/data/adb/modules/$NAME
  rm -f $DIR/update
  touch $DIR/remove
  FILE=/data/adb/modules/$NAME/uninstall.sh
  if [ -f $FILE ]; then
    sh $FILE
    rm -f $FILE
  fi
  rm -rf /metadata/magisk/$NAME\
   /mnt/vendor/persist/magisk/$NAME\
   /persist/magisk/$NAME\
   /data/unencrypted/magisk/$NAME\
   /cache/magisk/$NAME\
   /cust/magisk/$NAME
done
}

# function
cleanup() {
if [ -f $DIR/uninstall.sh ]; then
  sh $DIR/uninstall.sh
fi
DIR=/data/adb/modules_update/$MODID
if [ -f $DIR/uninstall.sh ]; then
  sh $DIR/uninstall.sh
fi
}

# cleanup
DIR=/data/adb/modules/$MODID
FILE=$DIR/module.prop
PREVMODNAME=`grep_prop name $FILE`
if [ "`grep_prop data.cleanup $OPTIONALS`" == 1 ]; then
  sed -i 's|^data.cleanup=1|data.cleanup=0|g' $OPTIONALS
  ui_print "- Cleaning-up $MODID data..."
  cleanup
  ui_print " "
elif [ -d $DIR ]\
&& [ "$PREVMODNAME" != "$MODNAME" ]; then
  ui_print "- Different module name is detected"
  ui_print "  Cleaning-up $MODID data..."
  cleanup
  ui_print " "
fi

# stream mode
FILE=$MODPATH/.aml.sh
PROP=`grep_prop stream.mode $OPTIONALS`
if echo "$PROP" | grep -q r; then
  ui_print "- Activating ring stream..."
  sed -i 's|#r||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q a; then
  ui_print "- Activating alarm stream..."
  sed -i 's|#a||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q s; then
  ui_print "- Activating system stream..."
  sed -i 's|#s||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q v; then
  ui_print "- Activating voice_call stream..."
  sed -i 's|#v||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q n; then
  ui_print "- Activating notification stream..."
  sed -i 's|#n||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q b; then
  ui_print "- Activating bluetooth_sco stream..."
  sed -i 's|#b||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q f; then
  ui_print "- Activating dtmf stream..."
  sed -i 's|#f||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q e; then
  ui_print "- Activating enforced_audible stream..."
  sed -i 's|#e||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q y; then
  ui_print "- Activating accessibility stream..."
  sed -i 's|#y||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q t; then
  ui_print "- Activating tts stream..."
  sed -i 's|#t||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q i; then
  ui_print "- Activating assistant stream..."
  sed -i 's|#i||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q c; then
  ui_print "- Activating call_assistant stream..."
  sed -i 's|#c||g' $FILE
  ui_print " "
fi
if [ "`grep_prop ozo.game $OPTIONALS`" != 0 ]; then
  sed -i 's|#p||g' $FILE
  sed -i 's|#g||g' $FILE
else
  ui_print "- Does not use OZO Game rerouting & patch stream"
  ui_print " "
fi

# function
copy_system_to_vendor() {
for NAME in $NAMES; do
  if [ "$IS64BIT" == true ]; then
    if [ -f $SYSTEM/lib64/$NAME ]; then
      cp -f $SYSTEM/lib64/$NAME $MODPATH/system/vendor/lib64
    else
      if file /*/bin/hw/*hardware*audio* | grep -q 64-bit; then
        ui_print "! $SYSTEM/lib64/$NAME"
        ui_print "  not found"
        ui_print "  This module will not work"
        ui_print "  Please send the install log to the author"
        ui_print " "
      fi
    fi
  fi
  if [ "$ABILIST32" ]; then
    if [ -f $SYSTEM/lib/$NAME ]; then
      cp -f $SYSTEM/lib/$NAME $MODPATH/system/vendor/lib
    else
      if file /*/bin/hw/*hardware*audio* | grep -q 32-bit; then
        ui_print "! $SYSTEM/lib/$NAME"
        ui_print "  not found"
        ui_print "  This module will not work"
        ui_print "  Please send the install log to the author"
        ui_print " "
      fi
    fi
  fi
done
}
file_check_apex_for_vendor() {
for FILE in $FILES; do
  DESS="/apex$FILE $SYSTEM/apex$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      NAME=`basename $FILE`
      if echo $FILE | grep -q lib64; then
        rm -f $MODPATH/system/vendor/lib64/$NAME
      else
        rm -f $MODPATH/system/vendor/lib/$NAME
      fi
      ui_print " "
    fi
  done
done
}
file_check_system_for_vendor() {
for FILE in $FILES; do
  DESS="$SYSTEM$FILE $SYSTEM_EXT$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      NAME=`basename $FILE`
      if echo $FILE | grep -q lib64; then
        rm -f $MODPATH/system/vendor/lib64/$NAME
      else
        rm -f $MODPATH/system/vendor/lib/$NAME
      fi
      ui_print " "
    fi
  done
done
}
file_check_vendor() {
for FILE in $FILES; do
  DESS="$VENDOR$FILE $ODM$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      rm -f $MODPATH/system/vendor$FILE
      ui_print " "
    fi
  done
done
}

# copy
NAMES="libutilscallstack.so libunwindstack.so liblzma.so"
copy_system_to_vendor

# check
if [ "$IS64BIT" == true ]; then
  FILES="/*vndk*/lib64/libutilscallstack.so
         /*vndk*/lib64/libunwindstack.so
         /*vndk*/lib64/liblzma.so"
  file_check_apex_for_vendor
fi
if [ "$ABILIST32" ]; then
  FILES="/*vndk*/lib/libutilscallstack.so
         /*vndk*/lib/libunwindstack.so
         /*vndk*/lib/liblzma.so"
  file_check_apex_for_vendor
fi
if [ "$IS64BIT" == true ]; then
  FILES="/lib64/vndk-*/libutilscallstack.so
         /lib64/vndk-*/libunwindstack.so
         /lib64/vndk-*/liblzma.so"
  file_check_system_for_vendor
fi
if [ "$ABILIST32" ]; then
  FILES="/lib/vndk-*/libutilscallstack.so
         /lib/vndk-*/libunwindstack.so
         /lib/vndk-*/liblzma.so"
  file_check_system_for_vendor
fi
if [ "$IS64BIT" == true ]; then
  FILES="/lib64/libutilscallstack.so
         /lib64/libunwindstack.so
         /lib64/liblzma.so"
  file_check_vendor
fi
if [ "$ABILIST32" ]; then
  FILES="/lib/libutilscallstack.so
         /lib/libunwindstack.so
         /lib/liblzma.so"
  file_check_vendor
fi

# directory
if [ "$API" -le 25 ]; then
  ui_print "- /vendor/lib*/soundfx is not supported in SDK 25 and bellow"
  ui_print "  Using /system/lib*/soundfx instead"
  cp -rf $MODPATH/system/vendor/lib* $MODPATH/system
  rm -rf $MODPATH/system/vendor/lib*
  ui_print " "
fi

# audio rotation
FILE=$MODPATH/service.sh
if [ "`grep_prop audio.rotation $OPTIONALS`" == 1 ]; then
  ui_print "- Enables ro.audio.monitorRotation=true"
  sed -i '1i\
resetprop -n ro.audio.monitorRotation true\
resetprop -n ro.audio.monitorWindowRotation true' $FILE
  ui_print " "
fi

# raw
FILE=$MODPATH/.aml.sh
if [ "`grep_prop disable.raw $OPTIONALS`" == 0 ]; then
  ui_print "- Does not disable Ultra Low Latency playback (RAW)"
  ui_print " "
else
  sed -i 's|#u||g' $FILE
fi

# run
. $MODPATH/copy.sh
. $MODPATH/.aml.sh





