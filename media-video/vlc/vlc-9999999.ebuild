# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here :# http://gentoo.zugaina.org/
#				Changes added by kiorky kiorky@cryptelium.net, dirty like way
#				:)
# This ebuild is a small modification of the official vlc ebuild

ESVN_REPO_URI="svn://svn.videolan.org/vlc/trunk"
#SVN_UPDATE_CMD="svn up -r 17800"
# Missing USE-flags due to missing deps:
# media-vidoe/vlc:tremor - Enables Tremor decoder support
# media-video/vlc:tarkin - Enables experimental tarkin codec
# media-video/vlc:h264 - Enables H264 encoding support with libx264

# Missing USE-flags due to needed testing
# media-video/vlc:dirac - Enables experimental dirac codec

inherit libtool toolchain-funcs eutils wxwidgets subversion

PATCHLEVEL="4"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"

LICENSE="GPL-2"
SLOT="0"
# ~sparc keyword dropped due to missing daap dependency.. mark or use.mask it
KEYWORDS="-*"
IUSE="a52 3dfx nls unicode debug altivec httpd vlm gnutls live v4l cdda ogg\
 matroska dvb dvd vcd ffmpeg aac dts flac mpeg vorbis theora X opengl freetype\ 
 svg fbcon svga oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc\
 joystick hal stream mp3 xv bidi gtk2 sdl png xml2 samba daap corba screen mod\
 speex audioscrobbler debug dirac ffmpeg fribidi java libcddb libcdio live555\
 mad musipac python qt qt4  qt_embedded quicktime real screen skins2 svg  tarkin\
 tremor  twolame dvb dvbpsi  vlm upnp debug   vorbis mpc "
RDEPEND="hal? ( >sys-apps/hal-0.4* )
		cdda? ( >=dev-libs/libcdio-0.71
			>=media-libs/libcddb-0.9.5 )
		live? ( >=media-plugins/live-2005.01.29 )
		dvd? (  media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ogg? ( media-libs/libogg )
		matroska? ( >=media-libs/libmatroska-0.8.0 )
		mp3? ( media-libs/libmad )
		ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20050226-r1 )
		a52? ( media-libs/a52dec )
		dts? ( media-libs/libdts )
		flac? ( media-libs/flac )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		vorbis? ( media-libs/libvorbis )
		theora? ( media-libs/libtheora )
		freetype? ( media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		svga? ( media-libs/svgalib )
		ggi? ( media-libs/libggi )
		aalib? ( media-libs/aalib )
		libcaca? ( media-libs/libcaca )
		arts? ( kde-base/arts )
		alsa? ( virtual/alsa )
		wxwindows? ( =x11-libs/wxGTK-2.6* )
		ncurses? ( sys-libs/ncurses )
		xosd? ( x11-libs/xosd )
		lirc? ( app-misc/lirc )
		3dfx? ( media-libs/glide-v3 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		opengl? ( virtual/opengl )
		sys-libs/zlib
		png? ( media-libs/libpng )
		media-libs/libdvbpsi
		aac? ( >=media-libs/faad2-2.0-r2 )
		sdl? ( >=media-libs/libsdl-1.2.8 )
		xml2? ( dev-libs/libxml2 )
		samba? ( net-fs/samba )
		vcd? ( >=dev-libs/libcdio-0.72
			>=media-video/vcdimager-0.7.21 )
		daap? ( >=media-libs/libopendaap-0.3.0 )
		corba? ( >=gnome-base/orbit-2.8.0
			>=dev-libs/glib-2.3.2 )
		v4l? ( sys-kernel/linux-headers )
		dvb? ( sys-kernel/linux-headers )
		joystick? ( sys-kernel/linux-headers )
		mod? ( media-libs/libmodplug )
		speex? ( media-libs/speex )
        dirac? ( media-video/dirac )
        svg? ( >=gnome-base/librsvg-2.5.0 )"
#		threads? ( dev-libs/pth )
#		portaudio? ( >=media-libs/portaudio-0.19 )
# 		mozilla? ( || (
# 			www-client/mozilla
# 			www-client/mozilla-firefox
# 			net-libs/gecko-sdk
# 			) )
# 		slp? ( net-libs/openslp )

DEPEND="${RDEPEND}
	dev-util/cvs
	>=sys-devel/gettext-0.11.5
	=sys-devel/automake-1.6*
	sys-devel/autoconf
	dev-util/pkgconfig"

pkg_setup() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use gtk2; then
			if use unicode; then
				need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
			else
				need-wxwidgets gtk2 || die "You need to install wxGTK with gtk2 support."
			fi
		else
			need-wxwidgets gtk || die "You need to install wxGTK with gtk support."
		fi
	fi
}

src_compile () {
	./bootstrap
	sed -i -e \
		"s:/usr/include/glide:/usr/include/glide3:;s:glide2x:glide3:" \
		configure || die "sed glide failed."

	# Fix the default font
	sed -i -e "s:/usr/share/fonts/truetype/freefont/FreeSerifBold.ttf:/usr/share/fonts/ttf-bitstream-vera/VeraBd.ttf:" modules/misc/freetype.c

	# Avoid timestamp skews with autotools
	touch configure.ac
	touch aclocal.m4
	touch configure
	touch config.h.in
	find . -name Makefile.in | xargs touch

	myconf="${myconf} "

#	if use mozilla; then
#		if has_version www-client/mozilla; then
#			XPIDL="/usr/bin/xpidl"
#			myconf="${myconf} MOZILLA_CONFIG=/usr/lib/mozilla/mozilla-config"
#		elif has_version www-client/mozilla-firefox; then
#			XPIDL="/usr/lib/MozillaFirefox/xpidl"
#			append-flags "-I/usr/$(get_libdir)/MozillaFirefox/include"
#		elif has_version net-libs/gecko-sdk; then
#			XPIDL="/usr/share/gecko-sdk/bin/xpidl"
#			append-flags "-I/usr/share/gecko-sdk/include"
#		fi
#	fi

	if use wxwindows; then
		myconf="${myconf} --enable-wxwidgets --with-wx-config=$(basename ${WX_CONFIG}) --with-wx-config-path=$(dirname ${WX_CONFIG})"
	fi

	if use ffmpeg; then
		if ! built_with_use media-video/ffmpeg pp;then
			eerror "FFMpeg must be build with GPLed postprocessing support (use 'pp')"
		fi
		if ! built_with_use media-video/ffmpeg swscaler;then 
			eerror "FFMpeg must	be build with swcale support (use 'swscaler')"
		fi;
		myconf="${myconf} --enable-ffmpeg"

		built_with_use media-video/ffmpeg aac \
			&& myconf="${myconf} --with-ffmpeg-aac"

		built_with_use media-video/ffmpeg dts \
			&& myconf="${myconf} --with-ffmpeg-dts"

		built_with_use media-video/ffmpeg zlib \
			&& myconf="${myconf} --with-ffmpeg-zlib"

		built_with_use media-video/ffmpeg encode \
			&& myconf="${myconf} --with-ffmpeg-mp3lame"
#to cut off? -> 	myconf="${myconf}  --with-ffmpeg-tree=/usr/lib" 
	else
		myconf="${myconf} --disable-ffmpeg"
	fi
	

	if use aac;then myconf="${myconf} --with-ffmpeg-faac";fi


	# Portaudio support needs at least v19
	# pth (threads) support is quite unstable with latest ffmpeg/libmatroska.
		./configure --prefix=/usr \
		--mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share \
		--sysconfdir=/etc --localstatedir=/var/lib \
		--disable-mozilla \
		--disable-portaudio \
		--disable-pth \
		--disable-slp --enable-debug \
		$(use_enable 3dfx glide) $(use_enable 3dfx glide) 	$(use_enable a52) \
		 	 $(use_enable aalib aa) 	$(use_enable alsa) \
		$(use_enable altivec) 	 $(use_enable arts) 		$(use_enable bidi fribidi) \
		$(use_enable cdda)       $(use_enable cdda cddax)	$(use_enable corba) \
		$(use_enable daap)  	 $(use_enable debug)        $(use_enable dirac) \
		$(use_enable dts)    $(use_enable dvb)  	 $(use_enable dvbpsi)          $(use_enable dvb pvr) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdplay) $(use_enable dvd dvdnav) \
		$(use_enable esd) 		 $(use_enable fbcon fb) \
		$(use_enable flac)       $(use_enable freetype)    	$(use_enable fribidi) \
		$(use_enable ggi) \
		$(use_enable gnutls) \
		$(use_enable hal) \
		$(use_enable httpd) \
		$(use_enable java java-bindings )\
		$(use_enable joystick) \
		$(use_enable libcaca caca) \
		$(use_enable libcddb)\
		$(use_enable libcdio)\
		$(use_enable lirc) \
		$(use_enable live555)\
		$(use_enable live livedotcom) $(use_with live livedotcom-tree /usr/lib/live) \
		$(use_enable mad)\
		$(use_enable matroska mkv) \
		$(use_enable mod) \
		$(use_enable mp3 mad) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable ncurses) \
		$(use_enable ogg) \
		$(use_enable opengl glx) $(use_enable opengl) \
		$(use_enable oss) \
		$(use_enable png) \
		$(use_enable qt4 qt4)\
		$(use_enable qt_embedded qte)\
		$(use_enable real real realrtsp)\
		$(use_enable samba smb) \
	    $(use_enable screen)\
		$(use_enable sdl) \
		$(use_enable speex) \
		$(use_enable stream sout) \
		$(use_enable svg )\
		$(use_enable svga svgalib) \
		$(use_enable tarkin)\
		$(use_enable theora) \
		$(use_enable tremor)\
		$(use_enable twolame)\
		$(use_enable upnp)\
		$(use_enable unicode utf8) \
		$(use_enable v4l) \
		$(use_enable vcd) $(use_enable vcd vcdx) \
		$(use_enable vlm)\
		$(use_enable vorbis)\
		$(use_enable wxwindows) \
		$(use_enable xml2 libxml2) \
		$(use_enable xosd) \
		$(use_enable xv xvideo) \
		${myconf} || die "configuration failed"

	if [[ $(gcc-major-version) == 2 ]]; then
		sed -i -e s:"-fomit-frame-pointer":: vlc-config || die "-fomit-frame-pointer patching failed"
	fi

#	use mozilla && sed -i -e "s:^XPIDL = .*:XPIDL = ${XPIDL}:" mozilla/Makefile \
#			|| die "could not fix XPIDL path"

	emake -j1 || die "make of VLC failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed!"

	dodoc ABOUT-NLS AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done

	make_desktop_entry vlc "VLC Media Player" vlc "AudioVideo;Player"
}
