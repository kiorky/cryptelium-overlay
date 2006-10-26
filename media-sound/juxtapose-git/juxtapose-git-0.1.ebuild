# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, For new version look here : http://gentoo.zugaina.org/

IUSE=""

inherit distutils git
DESCRIPTION="A python client for the XMMS2 music daemon which uses the GTK2 toolkit."

EGIT_REPO_URI="rsync://git.xmms.se/xmms2/juxtapose.git/"
EGIT_PROJECT="juxtapose"

HOMEPAGE="http://juxtapose.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~ppc ~sparc x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"

RDEPEND=">=dev-python/pygtk-2
	media-sound/xmms2-git"
S=${WORKDIR}/$EGIT_PROJECT

src_install() {
	python setup.py install
}
