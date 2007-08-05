# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/hpijs/hpijs-1.5.ebuild,v 1.13 2004/10/04 21:52:43 pvdabeel Exp $
# $author: KiOrKY
inherit gnuconfig eutils rpm

DESCRIPTION="Brother Compatible models and Driver for dcp310cn "
HOMEPAGE="http://solutions.brother.com/linux/sol/printer/linux/lpr_drivers.html"
SRC_URI="${DISTDIR}/DCP310CNlpr-1.0.2-1.i386.rpm"
LICENSE="Close"
SLOT="0"
KEYWORDS="x86 amd64"
DEPENDS="app-arch/rpm2targz  "
RESTRICT="fetch"
pkg_nofetch() {
	einfo "Please download ${PF} from: http://solutions.brother.com/linux/sol/printer/linux/lpr_drivers.html"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	 rpm_unpack ${DISTDIR}/DCP310CNlpr-1.0.2-1.i386.rpm
	 
}
src_install() {

	addpredict "/usr/local"
	einfo "Installing driver"
	exeinto /usr/bin
	doexe ${WORKDIR}/usr/bin/brprintconfij2
	insinto /usr/lib
	doins  ${WORKDIR}/usr/lib/libbrcompij2.so.1.0.2
	dodir /usr/local/Brother/
	insinto /usr/local/Brother/
	dodir /usr/local/Brother/inf
	dodir /usr/local/Brother/lpd
	insinto /usr/local/Brother/inf
	doins  ${WORKDIR}/usr/local/Brother/inf/*
	insinto /usr/local/Brother/lpd
	doins  ${WORKDIR}/usr/local/Brother/lpd/*
}

pkg_postinst() {
	einfo "Enjoy !!!!"
}
