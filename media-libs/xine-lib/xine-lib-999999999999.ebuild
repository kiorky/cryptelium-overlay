# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# author kiorky@cryptelium.net
inherit eutils flag-o-matic toolchain-funcs libtool autotools cvs

ECVS_SERVER="xine.cvs.sourceforge.net:/cvsroot/xine"
ECVS_MODULE="xine-lib"

PATCHLEVEL="61"

DESCRIPTION="Core libraries for Xine movie player || CVS VERSION"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="-*"

IUSE="a52 aac aalib alsa altivec arts debug directfb dts dvd dxr3 
      esd fbcon flac gnome gtk imagemagick ipv6 libcaca mad mmap 
	  mng modplug nls opengl oss pulseaudio samba sdl speex theora 
	  truetype v4l vcd vidix vorbis win32codecs X xinerama xv xvmc 
"

RDEPEND="
	a52? ( >=media-libs/a52dec-0.7.4-r5 )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	directfb? ( >=dev-libs/DirectFB-0.9.9 )
	dts? ( media-libs/libdts )
	dvd? ( >=media-libs/libdvdcss-1.2.7 )
	dxr3? ( >=media-libs/libfame-0.9.0 )
	esd? ( media-sound/esound )
	flac? ( >=media-libs/flac-1.1.2 )
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	gtk? ( =x11-libs/gtk+-2* )
	imagemagick? ( media-gfx/imagemagick )
	libcaca? ( >=media-libs/libcaca-0.99_beta1 )
	mad? ( media-libs/libmad )
	!=media-libs/xine-lib-0.9.13*
	>=media-video/ffmpeg-0.4.9_p20060816
	mng? ( media-libs/libmng )
	modplug? ( media-libs/libmodplug )
	nls? ( virtual/libintl )
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( net-fs/samba )
	sdl? ( >=media-libs/libsdl-1.1.5 )
	speex? ( media-libs/libogg media-libs/libvorbis media-libs/speex )
	theora? ( media-libs/libogg media-libs/libvorbis >=media-libs/libtheora-1.0_alpha6 )
	truetype? ( =media-libs/freetype-2* media-libs/fontconfig )
	vcd? ( media-video/vcdimager )
	virtual/libiconv
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	win32codecs? ( >=media-libs/win32codecs-0.50 )
	xinerama? ( x11-libs/libXinerama )
	xvmc? ( x11-libs/libXvMC )
	xv? ( x11-libs/libXv )
	X? ( x11-libs/libXext 
		 x11-libs/libX11 )	
	"

DEPEND="${RDEPEND}
	X? ( x11-libs/libXt
		 x11-proto/xproto
		 x11-proto/videoproto
		 x11-proto/xf86vidmodeproto
		 xinerama? ( x11-proto/xineramaproto ) )
	v4l? ( virtual/os-headers )
	dev-util/pkgconfig
	sys-devel/libtool
	nls? ( sys-devel/gettext )"

src_unpack() {
	cvs_src_unpack
	cd ${WORKDIR}/${PN}
	einfo  ${WORKDIR}/${PN}

}

src_compile() {
	pwd		
	cd ${WORKDIR}/${PN}

	./autogen.sh noconfig

	#prevent quicktime crashing
	append-flags -frename-registers -ffunction-sections

	# Specific workarounds for too-few-registers arch...
	if [[ $(tc-arch) == "x86" ]]; then
		filter-flags -fforce-addr
		filter-flags -momit-leaf-frame-pointer # break on gcc 3.4/4.x
		is-flag -O? || append-flags -O2
	fi

	# debug useflag used to emulate debug make targets. See bug #112980 and the
	# xine maintainers guide.
	use debug && append-flags -UNDEBUG -DDEBUG

	local myconf

	# enable/disable appropiate optimizations on sparc
	[[ "${PROFILE_ARCH}" == "sparc64" ]] && myconf="${myconf} --enable-vis"
	[[ "${PROFILE_ARCH}" == "sparc" ]] && myconf="${myconf} --disable-vis"

	# The default CFLAGS (-O) is the only thing working on hppa.
	use hppa && unset CFLAGS

	# Too many file names are the same (xine_decoder.c), change the builddir
	# So that the relative path is used to identify them.
	mkdir "${WORKDIR}/build"

	econf \
		$(use_enable gnome gnomevfs) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable samba) \
		$(use_enable altivec) \
		$(use_enable v4l) \
		\
		$(use_enable mng) \
		$(use_with imagemagick) \
		$(use_enable gtk gdkpixbuf) \
		\
		$(use_enable aac faad) \
		$(use_enable flac) \
		$(use_with vorbis) \
		$(use_with speex) \
		$(use_with theora) \
		$(use_enable a52) --with-external-a52dec \
		$(use_enable mad) --with-external-libmad \
		$(use_enable dts) --with-external-libdts \
		\
		$(use_with X x) \
		$(use_enable xinerama) \
		$(use_enable vidix) \
		$(use_enable dxr3) \
		$(use_enable directfb) \
		$(use_enable fbcon fb) \
		$(use_enable opengl) \
		$(use_enable aalib) \
		$(use_with libcaca caca) \
		$(use_with sdl) \
		$(use_enable xvmc) \
		\
		$(use_enable oss) \
		$(use_with alsa) \
		$(use_with arts) \
		$(use_with esd esound) \
		$(use_with pulseaudio) \
		$(use_enable vcd) --without-internal-vcdlibs \
		\
		$(use_enable win32codecs w32dll) \
		$(use_enable modplug) \
		\
		$(use_enable mmap) \
		$(use_enable truetype freetype) $(use_enable truetype fontconfig ) \
		--enable-asf \
		--with-external-ffmpeg \
		--disable-optimizations \
		${myconf} \
		--with-xv-path=/usr/$(get_libdir) \
		--with-w32-path=/usr/lib/win32 \
		--enable-fast-install \
		--disable-dependency-tracking || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/${PN}

	emake DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog README TODO doc/README* doc/faq/faq.txt
	dohtml doc/faq/faq.html doc/hackersguide/*.html doc/hackersguide/*.png

}
