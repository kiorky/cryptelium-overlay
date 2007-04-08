# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/xblast/xblast-2.10.2.ebuild,v 1.6 2006/12/01 19:52:26 wolf31o2 Exp $

inherit games

# Change these as releases changes
IMAGES="images-2005-01-06"
LEVELS="levels-2005-01-06"
MODELS="models-2005-01-06"
MUSICS="musics-2005-01-06"
SOUNDS="sounds"

DESCRIPTION="Bomberman clone w/network support for up to 6 players"
HOMEPAGE="http://xblast.sourceforge.net/"
SRC_URI="mirror://sourceforge/xblast/${P}.tar.gz
	mirror://sourceforge/xblast/${IMAGES}.tar.gz
	mirror://sourceforge/xblast/${LEVELS}.tar.gz
	mirror://sourceforge/xblast/${MODELS}.tar.gz
	mirror://sourceforge/xblast/${MUSICS}.tar.gz
	mirror://sourceforge/xblast/${SOUNDS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libICE
	x11-libs/libX11
	media-libs/libpng"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_compile() {
	export MY_DATADIR="${GAMES_DATADIR}/${PN}"
	egamesconf \
		--with-otherdatadir="${MY_DATADIR}" \
		--enable-sound \
		|| die
	emake || die "emake failed"
}

src_install() {
	local IMAGE_INSTALL_DIR="${GAMES_DATADIR}/${PN}/image"

	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README

	# Images
	dodir "${IMAGE_INSTALL_DIR}"
	find  "${WORKDIR}/${IMAGES}" -name "*" \
		-exec cp -pPR \{\} "${D}/${IMAGE_INSTALL_DIR}" \; \
		|| die

	# Levels
	dodir "${GAMES_DATADIR}/xblast/level" || die
	find "${WORKDIR}/${LEVELS}"  -name "*" \
		-exec  cp -pPR  \{\} "${D}/${GAMES_DATADIR}/xblast/level" \; \
		|| die

	# Models
	dodir "${GAMES_DATADIR}/xblast/image/sprite" || die
	find  "${WORKDIR}/${MODELS}" -name "*" \
		-exec cp -pPR  \{\}  "${D}/${GAMES_DATADIR}/xblast/image/sprite" \; \
		|| die

	# Music and sound
	dodir  "${GAMES_DATADIR}/xblast/sounds"
	find "${WORKDIR}/${MUSICS}" -name "*" \
		-exec cp -pPR  \{\} "${D}/${GAMES_DATADIR}/xblast/sounds" \; \
		|| die

	# Cleanup
	find "${D}" -name Imakefile -exec rm \{\} \;

	prepgamesdirs
}