# License GPL-2
# Author: kiorky@cryptelium.net
inherit eutils subversion flag-o-matic multilib toolchain-funcs
IUSE="debug threads mp4"

DESCRIPTION="A free library for encoding X264/AVC streams."
HOMEPAGE="http://developers.videolan.org/x264.html"
#SRC_URI="mirror://gentoo/${P}.tar.bz2"


ESVN_REPO_URI="svn://svn.videolan.org/x264/trunk"
ESVN_PROJECT="x264"
ESVN_FETCH_CMD="svn checkout"


SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-*"

RDEPEND=""

DEPEND="${RDEPEND}
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/nasm )
	x86-fbsd? ( dev-lang/nasm )"

S=${WORKDIR}/${PN}

src_unpack() {
	subversion_src_unpack  
	cd ${S}
#	epatch ${FILESDIR}/${P}-nostrip.patch
#	epatch ${FILESDIR}/${P}-onlylib.patch
}

src_compile() {
	./configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-pic --enable-shared \
		"--extra-cflags=${CFLAGS}" \
		"--extra-ldflags=${LDFLAGS}" \
		"--extra-asflags=${ASFLAGS}" \
		$(use_enable debug) \
		$(use_enable threads pthread) \
		--disable-mp4-output \
		$myconf \
		|| die "configure failed"
	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS
}

pkg_postinst() {
	einfo "Please note that this package now only installs"
	einfo "${PN} libraries. In order to have the encoder,"
	einfo "please emerge media-video/x264-svn-encoder"
}
