#!/usr/bin/env bash

set -ve
export EPREFIX="$HOME/Gentoo-bin"
rm -Rf $EPREFIX
export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"
export CHOST="x86_64-apple-darwin10"

export DISTFILES="$HOME/Library/Caches/Gentoo/distfiles"
mkdir -p $DISTFILES
mkdir -p $EPREFIX{,/tmp}/usr/portage/
ln -s $DISTFILES $EPREFIX/usr/portage
ln -s $DISTFILES $EPREFIX/tmp/usr/portage

curl "http://overlays.gentoo.org/proj/alt/browser/trunk/prefix-overlay/scripts/bootstrap-prefix.sh?format=txt" -o bootstrap-prefix.sh
chmod 755 bootstrap-prefix.sh

./bootstrap-prefix.sh $EPREFIX tree
./bootstrap-prefix.sh $EPREFIX portage
hash -r

export PORTAGE_BINHOST="file://$HOME/Library/Caches/Gentoo/packages"
FEATURES="-collision-protect" emerge -avg system

cd $EPREFIX/usr/portage/scripts
./bootstrap-prefix.sh $EPREFIX startscript

emerge --sync
