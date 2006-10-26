# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Non offical ebuild by Thus0. wma support added.

inherit eutils

WMA_PATCH="${P}-wma.patch"

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz
	http://www.cs.berkeley.edu/%7Eushankar/taglib-wma/taglib-wma-gentoo/${PN}-wma.tar.gz
	http://www.cs.berkeley.edu/%7Eushankar/taglib-wma/taglib-wma-gentoo/${WMA_PATCH}"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~mips"
IUSE="debug"

DEPEND="sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd ${S}
	tar -xvzf "${DISTDIR}"/${PN}-wma.tar.gz -C ${S}/taglib
	EPATCH_OPTS="-p1" epatch "${DISTDIR}"/${WMA_PATCH}

	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7
	aclocal && autoconf && automake || die "autotools failed"
}

src_compile() {
	econf $(use_enable debug) || die
	emake || die
	cd examples 
	make  
}

src_install() {
	exeinto /usr/bin
		doexe ${S}/examples/.libs/tagreader 
		#dobin tagreader_c 
		doexe ${S}/examples/.libs/tagwriter 
#		dobin framelist 
#		dobin strip-id3v1
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README TODO
}
