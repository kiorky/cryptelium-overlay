# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils games

MY_PN="${PN}-svn"

DESCRIPTION="Crossover between Quake and Worms."
HOMEPAGE="http://www.teewars.com"

ESVN_REPO_URI="svn://svn.teewars.com/teewars/trunk"

# see license.txt
LICENSE="as-is"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated server"

RDEPEND="!dedicated? (
		media-libs/alsa-lib
		media-libs/mesa
		x11-libs/libX11
		)
	!games-action/teewars-bin"
DEPEND="${RDEPEND}
	app-arch/zip"

S=${WORKDIR}

dir=${GAMES_DATADIR}/${MY_PN}

pkg_setup() {
	games_pkg_setup

	if use !debug; then
		einfo "You *should* consider \"debug\" USE flag as it is"
		einfo "unstable, testing version of the game"
	fi
}

src_unpack() {
	ESVN_REPO_URI1=${ESVN_REPO_URI}

	# checkout bam
	ESVN_REPO_URI="http://stalverk80.se/svn/bam"
#	ESVN_OPTIONS="-N"
	S="${S}/bam"
	subversion_src_unpack

	# checkout the game
	ESVN_REPO_URI=${ESVN_REPO_URI1}
	S="${S}/../${PN}"
	subversion_src_unpack

	S="${WORKDIR}"
	# fix bam default optimisation
	cd "${S}/bam"
	sed -i \
		-e "s|0 then f = f .. \"-O2 \"|0 then f = f .. \" \"|" \
		src/base.bam || die "sed base.bam failed"

	cd "${S}/${PN}"

	epatch ${FILESDIR}/${PN}-different-svn-config-dir-and-cleanup.patch

	sed -i \
		-e "s:data/:${dir}/data/:g" \
		datasrc/teewars.ds \
		src/game/client/gc_hooks.cpp \
		src/game/client/gc_map_image.cpp \
		src/game/client/gc_skin.cpp \
		src/game/editor/ed_editor.cpp \
		src/game/editor/ed_io.cpp \
		src/engine/e_map.c \
		src/engine/server/es_server.c \
		src/engine/client/ec_client.c || die "sed-ing default datadir location failed"
}

src_compile() {
	cd "${S}/bam"
	./make_unix.sh || die "make_unix.sh failed"

	cd "${S}/${PN}"
	# set optimisation
	sed -i \
		-e "s|flags = \"-Wall\"|flags = \"${CXXFLAGS}\"|" \
		-e "s|linker.flags = \"\"|linker.flags = \"${LDFLAGS}\"|" \
		default.bam || die "sed failed"

	if use debug && use server; then
		../bam/src/bam -v debug || die "bam failed"
	elif use debug && use dedicated; then
		../bam/src/bam -v server_debug || die "bam failed"
	elif use !debug && use dedicated; then
		../bam/src/bam -v server_release || die "bam failed"
	else
		../bam/src/bam -v release || die "bam failed"
	fi
}

src_install() {
	cd "${S}/${PN}"
	if use dedicated; then
		insinto "${dir}"/data/maps
		doins data/maps/* || die "doins failed"
	else
		insinto "${dir}"
		doins -r data || die "doins failed"
	fi

	if use debug && use server; then
		newgamesbin ${PN}_srv_d ${MY_PN}_srv || die "dogamesbin failed"
		newgamesbin ${PN}_d ${MY_PN} || die "dogamesbin failed"
		make_desktop_entry ${MY_PN} "Teewars-svn"
	elif use !debug && use server; then
		newgamesbin ${PN}_srv ${MY_PN}_srv || die "dogamesbin failed"
		newgamesbin ${PN} ${MY_PN} || die "dogamesbin failed"
		make_desktop_entry ${MY_PN} "Teewars-svn"
	elif use debug && use dedicated; then
		newgamesbin ${PN}_srv_d ${MY_PN}_srv || die "dogamesbin failed"
	elif use !debug && use dedicated; then
		newgamesbin ${PN}_srv ${MY_PN}_srv || die "dogamesbin failed"
	else
		newgamesbin ${PN} ${MY_PN} || die "dogamesbin failed"
		make_desktop_entry ${MY_PN} "Teewars-svn"
	fi

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo "Take a note that SVN version of teewars creates his own dir for"
	einfo "config, because it sometimes fails to load the \"stable\" one."
	einfo "You can find new config in ~/.${MY_PN}"

	if use server || use dedicated; then
		einfo "For more information about server setup read:"
		einfo "http://www.teewars.com/?page=docs"
	fi
}
