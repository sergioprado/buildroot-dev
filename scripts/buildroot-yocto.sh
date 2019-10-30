#!/bin/sh

YOCTO=$(eval echo $1)
BUILDROOT=$(eval echo $2)

exit_error()
{
	echo "Error: $1!"
	exit 1
}

get_pkgs_yocto()
{
	for f in $(find $YOCTO/recipes*/*/*.bb); do
		FILENAME=$(basename $f)
		PKGNAME=$(echo $FILENAME | cut -d '_' -f 1)
		PKGS="$PKGS $PKGNAME"
	done
}

if [ -z "$YOCTO" -o ! -e "$YOCTO/conf/layer.conf" ]; then
	exit_error "Invalid Yocto layer directory"
fi

if [ -z "$BUILDROOT" -o ! -e "$BUILDROOT/package/Config.in" ]; then
	exit_error "Invalid Buildroot directory"
fi

get_pkgs_yocto

for f in $PKGS; do
	RET=$(find "$BUILDROOT/package/" -name $f)
	if [ -z "$RET" ]; then
		echo "PACKAGE [$f] NOT FOUND!"
	fi
done

echo OK!
