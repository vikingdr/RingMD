#!/bin/sh

BUILD="`date '+%Y-%m-%d [%H:%M:%S]'`"
export BUILD

agvtool new-version -all "$BUILD"
