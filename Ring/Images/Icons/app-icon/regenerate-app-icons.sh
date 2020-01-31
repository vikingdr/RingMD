#!/bin/sh

MASTERFILE=master-app-icon.png

test -f "$MASTERFILE" || { echo "$MASTERFILE not found"; exit 1; }

for WIDTH in 29 40 57 60 29 40 50 72 76
do
  WIDTH2X=$[2*$WIDTH]
  WIDTH3X=$[3*$WIDTH]
  PREFIX="app-icon-$WIDTH"

  cp "$MASTERFILE" "$PREFIX.png"
  sips -Z "$WIDTH" "$PREFIX.png"

  cp "$MASTERFILE" "$PREFIX@2x.png"
  sips -Z "$WIDTH2X" "$PREFIX@2x.png"

  cp "$MASTERFILE" "$PREFIX@3x.png"
  sips -Z "$WIDTH3X" "$PREFIX@3x.png"
done
