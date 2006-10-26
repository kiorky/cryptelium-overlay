# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, additions by Oliver Schneider. For new version look here : http://gentoo.zugaina.org/


EGIT_REPO_URI="rsync://git.xmms.se/xmms2/gxmms2.git/"
EGIT_PROJECT="gxmms2"
IUSE=""
DESCRIPTION="A GTK+ 2.6 based XMMS2 client (git version)"
HOMEPAGE="http://wejp.homelinux.org/wejp/xmms2/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~ppc ~sparc x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"

RDEPEND=">=x11-libs/gtk+-2.6
	media-sound/xmms2-git"
S=${WORKDIR}/$EGIT_PROJECT
inherit eutils git

src_compile() {
	make clean
	cp ${FILESDIR}/gxmms2-Makefile-gentoo ${S}/Makefile
	emake || die "make failed"
}

src_install() {
	dodir /usr/local/gxmms2-snaphot-`date +%Y%m%d`/bin
	exeinto /usr/local/gxmms2-snaphot-`date +%Y%m%d`/bin
	doexe gxmms2
}
