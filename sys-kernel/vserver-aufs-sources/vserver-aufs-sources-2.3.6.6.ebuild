# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vserver-sources/vserver-sources-2.3.6.5.ebuild,v 1.1 2013/08/02 07:22:49 dev-zero Exp $

EAPI="5"
ETYPE="sources"
CKV="3.10.17"
K_USEPV=1
K_NOSETEXTRAVERSION=1
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="24"
K_DEBLOB_AVAILABLE="1"
UNIPATCH_STRICTORDER=1
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~amd64 ~hppa ~x86"
DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree and aufs3 support and vserver support"
HOMEPAGE="http://www.gentoo.org/proj/en/vps/"
IUSE="deblob module proc vanilla"
PDEPEND=">=sys-fs/aufs-util-3.2"

AUFS_VERSION=${KV_MAJOR}.${KV_MINOR}_p20131014
AUFS_TARBALL="aufs-sources-${AUFS_VERSION}.tar.xz"
AUFS_URI="http://dev.gentoo.org/~jlec/distfiles/${AUFS_TARBALL}"
# git archive -v --remote=git://git.code.sf.net/p/aufs/aufs3-standalone aufs${AUFS_VERSION/_p*} > aufs-sources-${AUFS_VERSION}.tar


SRC_URI="
	${KERNEL_URI}
	http://vserver.13thfloor.at/Experimental/patch-${CKV}-vs${PV}.diff
	${ARCH_URI}
	${AUFS_URI}
	!vanilla? ( ${GENPATCHES_URI} )
	"

src_unpack() {
	if use vanilla; then
		unset UNIPATCH_LIST_GENPATCHES UNIPATCH_LIST_DEFAULT
		ewarn "You are using USE=vanilla"
		ewarn "This will drop all support from the gentoo kernel security team"
	fi

	UNIPATCH_LIST="${DISTDIR}/patch-${CKV}-vs${PV}.diff"
	UNIPATCH_LIST="$UNIPATCH_LIST "${WORKDIR}"/aufs3-kbuild.patch "${WORKDIR}"/aufs3-base.patch"
	use module && UNIPATCH_LIST+=" "${WORKDIR}"/aufs3-standalone.patch"
	use proc && UNIPATCH_LIST+=" "${WORKDIR}"/aufs3-proc_map.patch"
	unpack ${AUFS_TARBALL}
	kernel-2_src_unpack
}

src_prepare() {
	if ! use module; then
		sed -e 's:tristate:bool:g' -i "${WORKDIR}"/fs/aufs/Kconfig || die
	fi
	if ! use proc; then
		sed '/config AUFS_PROC_MAP/,/^$/d' -i "${WORKDIR}"/fs/aufs/Kconfig || die
	fi
	cp -f "${WORKDIR}"/include/linux/aufs_type.h include/linux/aufs_type.h || die
	cp -f "${WORKDIR}"/include/linux/aufs_type.h include/linux/aufs_type.h || die
	cp -rf "${WORKDIR}"/{Documentation,fs} . || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	has_version sys-fs/aufs-util && \
		einfo "In order to use aufs FS you need to install sys-fs/aufs-util"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
