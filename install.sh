#!/usr/bin/env bash

export MAKEOPTS="-j6"
set -ve
export EPREFIX="$HOME/Gentoo"
rm -Rf $EPREFIX
export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"
export CHOST="x86_64-linux-gnu"

export DISTFILES="$HOME/.cache/Gentoo/distfiles"
mkdir -p $DISTFILES
mkdir -p $EPREFIX{,/tmp}/usr/portage/
ln -s $DISTFILES $EPREFIX/usr/portage
ln -s $DISTFILES $EPREFIX/tmp/usr/portage

curl "http://overlays.gentoo.org/proj/alt/browser/trunk/prefix-overlay/scripts/bootstrap-prefix.sh?format=txt" -o bootstrap-prefix.sh
chmod 755 bootstrap-prefix.sh

./bootstrap-prefix.sh $EPREFIX tree
./bootstrap-prefix.sh $EPREFIX/tmp make
./bootstrap-prefix.sh $EPREFIX/tmp wget
./bootstrap-prefix.sh $EPREFIX/tmp sed
./bootstrap-prefix.sh $EPREFIX/tmp python
./bootstrap-prefix.sh $EPREFIX/tmp coreutils6
./bootstrap-prefix.sh $EPREFIX/tmp findutils
./bootstrap-prefix.sh $EPREFIX/tmp tar15
./bootstrap-prefix.sh $EPREFIX/tmp patch9
./bootstrap-prefix.sh $EPREFIX/tmp grep
./bootstrap-prefix.sh $EPREFIX/tmp gawk
./bootstrap-prefix.sh $EPREFIX/tmp bash
./bootstrap-prefix.sh $EPREFIX/tmp zlib
./bootstrap-prefix.sh $EPREFIX portage
hash -r

emerge --oneshot sed

emerge --oneshot --nodeps bash
emerge --oneshot --nodeps wget

emerge --oneshot --nodeps baselayout-prefix
emerge --oneshot --nodeps xz-utils
emerge --oneshot --nodeps m4
emerge --oneshot --nodeps flex
emerge --oneshot --nodeps bison
emerge --oneshot --nodeps binutils-config
emerge --oneshot --nodeps binutils
emerge --oneshot --nodeps gcc-config
emerge --oneshot --nodeps gcc

emerge --oneshot coreutils
emerge --oneshot findutils
emerge --oneshot tar
emerge --oneshot grep
emerge --oneshot patch
emerge --oneshot gawk
emerge --oneshot make
emerge --oneshot --nodeps file
emerge --oneshot --nodeps eselect
emerge --oneshot pax-utils

env FEATURES="-collision-protect" emerge --oneshot portage

rm -Rf $EPREFIX/tmp
ln -s /tmp $EPREFIX/tmp
hash -r

emerge --sync
USE=-git emerge -u system

echo 'USE="unicode nls"' >> $EPREFIX/etc/make.conf
echo 'CFLAGS="-O3 -march=native -pipe"' >> $EPREFIX/etc/make.conf # -march=native doesn't work here, why?
echo 'CXXFLAGS="${CFLAGS}"' >> $EPREFIX/etc/make.conf
echo 'MAKEOPTS="-j6"' >> $EPREFIX/etc/make.conf

emerge -e system

cd $EPREFIX/usr/portage/scripts
./bootstrap-prefix.sh $EPREFIX startscript
