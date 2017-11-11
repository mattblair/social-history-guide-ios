#!/bin/bash
f=$(pwd)

# Last Updated: 171110, for iOS 11

# To run: bash ios-icon-resize.sh <1024x1024-icon-file.png> <subdirectory>
# May also start with 2048x2048 icon png

# example:
# bash ios-icon-resize.sh pshgAppIcon1024.png pshgIcons171110


mkdir -p ${f}/${2};

sips --resampleWidth 512 "${f}/${1}" --out "${f}/${2}/iTunesArtwork"
sips --resampleWidth 1024 "${f}/${1}" --out "${f}/${2}/iTunesArtwork@2x"

sips --resampleWidth 1024 "${f}/${1}" --out "${f}/${2}/Icon-AppStore.png"


# iPhone Notification iOS 7 - 11
# 20pt 
#@2x, @3x
sips --resampleWidth 40 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Notification@2x.png"
sips --resampleWidth 60 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Notification@3x.png"

# iPhone Settings iOS 5 - 11
# 29pt 
# @2x, @3x
sips --resampleWidth 58 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Settings@2x.png"
sips --resampleWidth 87 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Settings@3x.png"

# iPhone Spotlight iOS 7 - 11
# 40pt
# @2x, @3x
sips --resampleWidth 80 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Spotlight@2x.png"
sips --resampleWidth 120 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-Spotlight@3x.png"

# iPhone App iOS 7 - 11
# 60pt
# @2x, @3x
sips --resampleWidth 120 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-App@2x.png"
sips --resampleWidth 180 "${f}/${1}" --out "${f}/${2}/Icon-iPhone-App@3x.png"

# iPad Notification iOS 7 - 11
# 20pt 
#@1x, @2x
sips --resampleWidth 20 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Notification.png"
sips --resampleWidth 40 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Notification@2x.png"

# iPad Settings iOS 5-11
# 29pt
# @1x, @2x
sips --resampleWidth 29 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Settings.png"
sips --resampleWidth 58 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Settings@2x.png"

# iPad Spotlight iOS 7-11
# 40pt
# @1x, @2x
sips --resampleWidth 40 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Spotlight.png"
sips --resampleWidth 80 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Spotlight@2x.png"

# iPad App iOS 7-11
# 76pt
# @1x, @2x
sips --resampleWidth 76 "${f}/${1}" --out "${f}/${2}/Icon-iPad-App.png"
sips --resampleWidth 152 "${f}/${1}" --out "${f}/${2}/Icon-iPad-App@2x.png"

# iPad Pro App iOS 9 - 11
# 83.5
# @2x
sips --resampleWidth 167 "${f}/${1}" --out "${f}/${2}/Icon-iPad-Pro-App@2x.png"
