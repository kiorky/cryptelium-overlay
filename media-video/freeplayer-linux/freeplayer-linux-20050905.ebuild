# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fluxbox/fluxbox-0.9.13-r1.ebuild,v 1.10 2005/07/19 20:47:37 kloeri Exp $

inherit eutils

IUSE=""

DESCRIPTION="Freeplayer util to stream media to freebox over LAN"
SRC_URI="ftp://ftp.free.fr/pub/freeplayer/${P}.tgz"
HOMEPAGE="http://www.fluxbox.org"

# Please note that USE="kde gnome" simply adds support for the respective
# protocols, and does not depend on external libraries. They do, however,
# make the binary a fair bit bigger, so we don't want to turn them on unless
# the user actually wants them.

RDEPEND="media-video/vlc-svn"
DEPEND=">=sys-devel/autoconf-2.52 media-video/vlc-svn ${RDEPEND}"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86"

src_unpack() {
	unpack ${A}
	cd "freeplayer"
	pwd
	exit
}


src_install() {
	pwd
	cd ${WORKDIR}/freeplayer
	pwd
	INSTALL_PATH='/usr/local/freeplayer'
	# install the package
	dodir	-p $INSTALL_PATH/bin
	echo "Installing package..."
	exeinto $INSTALL_PATH/bin
	for file in ${WORKDIR}/freeplayer/bin/* ; do
		doexe  $file
	done ;
	insinto $INSTALL_PATH
	doins -r  ./share
	addpredict "$INSTALL_PATH"
	sed s^%HTTP_PATH%^$INSTALL_PATH/share/http-fbx/^ -i $INSTALL_PATH/bin/vlc-fbx.sh
	echo "Done, have fun"
}

