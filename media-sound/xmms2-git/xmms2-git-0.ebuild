# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild come with modification from Beber

inherit eutils git


EGIT_PROJECT="xmms2-devel"
EGIT_REPO_URI="rsync://git.xmms.se/xmms2/xmms2-devel.git"
DESCRIPTION="Xplatform Music Multiplexing System.The new generation of the XMMS player.Developpement Version!"
HOMEPAGE="http://xmms2.xmms.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64 sparc"
IUSE="ogg sid python ruby"

RESTRICT="nomirror"

DEPEND=">=dev-lang/python-2.2.1
	>=dev-util/scons-0.94
	>=dev-libs/glib-2.2.0
	media-libs/libmad
	>=dev-db/sqlite-3.2
	>=net-misc/curl-7.11.2
	ogg? ( media-libs/libvorbis )
	sid? ||( media-sound/sidplay
			media-libs/resid )
	python? ( dev-python/pyrex )
	!python? ( !dev-python/pyrex )
	ruby? ( >=dev-lang/ruby-1.8 )"
S=${WORKDIR}/$EGIT_PROJECT
pkg_setup() {
	enewuser xmms2 -1 /bin/bash /dev/null users
}

src_compile() {
	# The only way I found to install the ebuild with scons...
	PYTHON_V=`python-config | tr ' ' '\n' | grep -E -- '-lpython' | cut -c 3-`
#	addpredict "/usr/lib"
#	addpredict "/usr/include/glib-2.0"
#	addpredict "/usr/include/glib-2.0/glib"
#	use python && addpredict "/usr/include/${PYTHON_V}"
#	addpredict "/usr/include"
	scons INSTALLDIR=${D} PREFIX="/usr/local/${MY_P}" ${MAKEOPTS} SYSCONFDIR="/usr/local/${MY_P}/etc" || die
}

src_install() {
	scons INSTALLDIR=${D} PREFIX="/usr/local/${MY_P}" ${MAKEOPTS} SYSCONFDIR="/usr/local/${MY_P}/etc" install || die
	exeinto /usr/local/${MY_P}/etc/init.d
	newexe ${FILESDIR}/xmms2-initscript-gentoo xmms2d
	insinto /usr/local/${MY_P}/etc/conf.d
	newins ${FILESDIR}/xmms2-initscript-gentoo.conf xmms2d
	dodoc AUTHORS COPYING TODO README
}

