# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dirac/dirac-0.6.0.ebuild,v 1.1 2007/01/20 08:43:44 hanno Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools cvs

ECVS_MODULE="compress"
ECVS_SERVER="dirac.cvs.sourceforge.net:/cvsroot/dirac"

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI=""

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="-*"
IUSE="mmx debug doc"

DEPEND="doc? ( app-doc/doxygen
	virtual/tetex )"
RDEPEND=""

S="${WORKDIR}/compress"

src_unpack() {
	cvs_src_unpack

	cd "${S}" || die "cd failed"

	epatch "${FILESDIR}/${PN}-0.5.2-doc.patch"

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable mmx) \
		$(use_enable debug) \
		$(use_enable doc) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		latexdir="/usr/share/doc/${PF}/programmers" \
		algodir="/usr/share/doc/${PF}/algorithm" \
		faqdir="/usr/share/doc/${PF}" \
		install

	dodoc README AUTHORS NEWS TODO ChangeLog
}
