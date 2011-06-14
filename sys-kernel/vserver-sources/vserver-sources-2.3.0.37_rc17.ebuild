# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
ETYPE="sources"
CKV="2.6.38"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="8"
K_DEBLOB_AVAILABLE="1"

K_USEPV=1
K_NOSETEXTRAVERSION=1

inherit kernel-2
detect_version

KEYWORDS="amd64 hppa x86"
IUSE=""

DESCRIPTION="Full sources including Gentoo and Linux-VServer patchsets for the ${KV_MAJOR}.${KV_MINOR} kernel tree."
HOMEPAGE="http://www.gentoo.org/proj/en/vps/"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} http://bordel.cryptelium.net/patch-${CKV}-vs${PVR}.patch.tar.bz2"
UNIPATCH_LIST="${DISTDIR}/patch-${CKV}-vs${PVR}.patch.tar.bz2"
