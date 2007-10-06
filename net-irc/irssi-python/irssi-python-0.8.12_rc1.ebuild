# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-0.8.12_rc1.ebuild,v 1.2 2007/09/22 19:13:41 swegener Exp $

inherit eutils subversion

MY_PV="${PV/_/-}"

DESCRIPTION="python bindings for irssi"
HOMEPAGE="http://irssi.org/"
SRC_URI="http://irssi.org/files/irssi-${MY_PV}.tar.bz2"
ESVN_REPO_URI="http://svn.irssi.org/repos/irssi-python"
ESVN_PROJECT="irssi-python"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

COMMON_DEPEND="
dev-lang/python
net-irc/irssi-python
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"

src_unpack() {
	subversion_src_unpack
	unpack ${A}
	epunt_cxx
}

src_compile() {
	econf \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		install || die "make install failed"

	use perl && fixlocalpod

	dodoc AUTHORS ChangeLog README TODO NEWS || die "dodoc failed"
}
