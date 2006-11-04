# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wormux/wormux-0.7.4.ebuild,v 1.2 2006/11/02 04:44:19 josejx Exp $

inherit eutils debug games

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://www.wormux.org/"
MY_P="${PN}-0.8alpha1"
SRC_URI="http://download.gna.org/wormux/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug nls"

RDEPEND=">=media-libs/libsdl-1.2.6
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-ttf-2.0
	media-libs/sdl-net
	>=media-libs/sdl-gfx-2.0.13
	>=dev-cpp/libxmlpp-2.6
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/${MY_P}"
#	epatch "${FILESDIR}/${P}-user-CFLAGS.patch"
	# avoid the strip on install
	sed -i \
		-e "s/@INSTALL_STRIP_PROGRAM@/@INSTALL_PROGRAM@/" \
		src/Makefile.in \
		|| die "sed failed"
}

src_compile() {
	cd "${WORKDIR}/${MY_P}"
	egamesconf \
		--with-datadir-name="${GAMES_DATADIR}/${PN}" \
		--with-localedir-name="/usr/share/locale" \
		$(use_enable debug) \
		$(use_enable nls) \
		|| die
	emake || die "emake failed"
}

src_install() {
	cd "${WORKDIR}/${MY_P}"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
	newicon data/wormux-32.xpm wormux.xpm
	make_desktop_entry wormux Wormux wormux.xpm
	prepgamesdirs
}


