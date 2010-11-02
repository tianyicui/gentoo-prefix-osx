#!/usr/bin/env bash

set -ve
export EPREFIX="$HOME/Gentoo"
rm -Rf $EPREFIX
export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"
export CHOST="x86_64-apple-darwin10"

export DISTFILES="$HOME/distfiles"
mkdir -p $DISTFILES
mkdir -p $EPREFIX{,/tmp}/usr/portage/
ln -s $DISTFILES $EPREFIX/usr/portage
ln -s $DISTFILES $EPREFIX/tmp/usr/portage

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
./bootstrap-prefix.sh $EPREFIX portage
hash -r

emerge --oneshot sed
emerge --oneshot --nodeps bash
emerge --oneshot pax-utils
emerge --oneshot --nodeps wget \
	baselayout-prefix \
	xz-utils \
	m4 \
	flex \
	bison \
	binutils-config \
	binutils-apple \
	gcc-config \
	gcc-apple
emerge --oneshot coreutils \
	findutils \
	tar \
	grep \
	patch \
	gawk \
	make
emerge --oneshot --nodeps file \
	eselect
env FEATURES="-collision-protect" emerge --oneshot portage
rm -Rf $EPREFIX/tmp/*
hash -r

emerge --sync
USE=-git emerge -u system
