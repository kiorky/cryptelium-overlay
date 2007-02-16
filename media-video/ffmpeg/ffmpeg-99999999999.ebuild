# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic multilib toolchain-funcs

ESVN_REPO_URI="svn://svn.mplayerhq.hu/ffmpeg/trunk"
ESVN_PROJECT="ffmpeg"
ESVN_FETCH_CMD="svn checkout"

MY_P=${P/_/-}

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec. (source from CVS)"
HOMEPAGE="http://ffmpeg.sourceforge.net/"
SRC_URI="
	amr? ( http://dev.gentooexperimental.org/~kiorky/26104-510.zip )
	amr? ( http://dev.gentooexperimental.org/~kiorky/26204-510.zip )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="a52 aac altivec amr avisynth doc dts encode faac faad gpl ieee1394 mmx mp3
network ogg opts oss pp  swscaler theora threads v4l vorbis x264 xvid zlib "

DEPEND="
	a52? ( >=media-libs/a52dec-0.7.4-r4 )
	aac? ( media-libs/faad2 media-libs/faac )
	doc? ( app-text/texi2html )
	dts? ( media-libs/libdts )
	encode? ( media-sound/lame )
	faad? (  media-libs/faad2 )
	ieee1394? ( =media-libs/libdc1394-1*  sys-libs/libraw1394 )
	imlib? ( media-libs/imlib2 )
	ogg? ( media-libs/libogg )
	test? ( net-misc/wget )
	theora? ( media-libs/libtheora )
	truetype? ( >=media-libs/freetype-2 )
	vorbis? ( media-libs/libvorbis )
	x264? ( >=media-libs/x264-svn-999999999 )
	xvid? ( media-libs/xvid )
	zlib? ( sys-libs/zlib )
"

RDEPEND="${DEPEND}"
S="${WORKDIR}"


src_unpack() {
	subversion_src_unpack
	if use "amr"; then
		einfo "Patching for amr wide and narrow band (float) support ... "

		# narrow band codec
		mkdir "${S}/libavcodec/amr_float" || die "mkdir failed"
		unzip -q "${FILESDIR}/26104-510.zip" \
			-d "${S}/libavcodec/amr_float" || die "unzip failed"
		unzip -q 26104-510_ANSI_C_source_code.zip \
			-d "${S}/libavcodec/amr_float" || die "unzip ansi failed"

		# wide band codec
		mkdir "${S}/libavcodec/amrwb_float" || die "mkdir libavcodec failed"
		unzip -q ${FILESDIR}/26204-510.zip \
			-d "${S}/libavcodec/amrwb_float"  || die "unzip2 failed"
		unzip -q 26204-510_ANSI-C_source_code.zip \
			-d "${S}/libavcodec/amrwb_float"|| die "unzip2 ansi failed"

		# Patch if we're on 64-bit
		if useq alpha || useq amd64 || useq ia64 || useq ppc64; then
			cd "libavcodec" || die cd failed
			epatch "${FILESDIR}/ffmpeg-amr-64bit.patch"
			cd "${S}" || die "return2 cd failed"
		fi
	fi
}

src_compile() {
	filter-flags -fforce-addr -momit-leaf-frame-pointer
	local myconf=""
	if use "avisynth"; then
		myconf="${myconf} --enable-avisynth"
	fi
	if ! use "altivec"; then
		myconf="${myconf} --disable-altivec"
	fi
	# amr (float) support
	local	dir=$(pwd)
	if use "amr"; then
		einfo "Including amr wide and narrow band (float) support ... "
		myconf="${myconf} --enable-amr_nb"
		myconf="${myconf} --enable-amr_wb" # --enable-amr_if2"
	fi
	if use "a52"; then
		myconf="${myconf} --enable-liba52"
	fi
	if ! use "network"; then
		myconf="${myconf}  --disable-protocols --disable-ipv6 --disable-network --disable-ffserver"
	fi
	if use "faac"; then
		myconf="${myconf} --enable-libfaac"
	fi
	if use "faad"; then
		myconf="${myconf} --enable-libfaad"
	fi
	if use "threads"; then
		myconf="${myconf} --enable-pthreads"
	fi
	if use "pp"; then
		myconf="${myconf} --enable-pp"
	fi
	if use "gpl"; then
		myconf="${myconf} --enable-gpl"
	fi
	if use "mp3"; then
		myconf="${myconf} --enable-libmp3lame"
	fi
	if ! use "opts"; then
		myconf="${myconf} --disable-opts"
	fi
	if use "ogg"; then
		myconf="${myconf} --enable-libogg"
	fi
	if use "swscaler"; then
		myconf="${myconf} --enable-swscaler"
	fi
	if use "theora"; then
		myconf="${myconf} --enable-libtheora"
	fi
	if use "vorbis"; then
		myconf="${myconf} --enable-libvorbis"
	fi
	if ! use "v4l";then
		myconf="${myconf} --disable-v4l"
	fi
	if use "x264"; then
		myconf="${myconf} --enable-x264"
	fi
	if use "xvid"; then
		myconf="${myconf} --enable-xvid"
	fi

	./configure --prefix=/usr --mandir=/usr/share/man   \
	--disable-static --enable-shared  ${myconf} || die "Configure failed"

	# custom version hook
	FFMPEG_VERSION=$(LANG=C LC_ALL=C svn info \
	${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/${PN}/trunk | \
	grep    Revision|sed    -re "s/.*:\s*//g" || die "svn retrieve failed" )
	FFMPEG_VERSION="\"dev-SVN-r$FFMPEG_VERSION "
	FFMPEG_VERSION="$FFMPEG_VERSION built on $(date "+%Y-%m-%d %H:%m" || die "date failed") \""
	einfo "FFMpeg version set to:  $FFMPEG_VERSION"
	FFMPEG_VERSION="#define FFMPEG_VERSION $FFMPEG_VERSION"
	echo "$FFMPEG_VERSION" > version.h || die "echo failed"

	emake  || die "Compilation failed"
}

src_install() {
	addpredict "/usr"
	addpredict "/usr/lib"
	use doc && make documentation

	cd "${S}" || die "cd failed"
	make DESTDIR="${D}" install  || die "Install Failed"

	dodoc ChangeLog README INSTALL
	dodoc doc/*
}
