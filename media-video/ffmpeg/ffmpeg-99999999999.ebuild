# Distributed under the terms of the GNU General Public License v2
# author: kiorky kiorky@cryptelium.net

inherit subversion flag-o-matic multilib toolchain-funcs

ESVN_REPO_URI="svn://svn.mplayerhq.hu/ffmpeg/trunk"
ESVN_PROJECT="ffmpeg"
ESVN_FETCH_CMD="svn checkout "
#ESVN_UPDATE_CMD="svn up -r 5944 "
#ESVN_UPDATE_CMD="svn up -r 7000"
#ESVN_UPDATE_CMD="svn up -r HEAD "

MY_P=${P/_/-}
S=${WORKDIR}/

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec. (source from CVS)"
HOMEPAGE="http://ffmpeg.sourceforge.net/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=" swscaler avisynth a52 aac altivec doc dts encode faac faad gpl ieee1394 mmx mp3 network ogg opts oss pp  threads v4l vorbis x264 xvid  zlib "

DEPEND="imlib? ( media-libs/imlib2 )
	truetype? ( >=media-libs/freetype-2 )
	doc? ( app-text/texi2html )
	encode? ( media-sound/lame )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	aac? ( media-libs/faad2 media-libs/faac )
	a52? ( >=media-libs/a52dec-0.7.4-r4 )
	xvid? ( >=media-libs/xvid-1.0 )
	zlib? ( sys-libs/zlib )
	dts? ( media-libs/libdts )
	ieee1394? ( =media-libs/libdc1394-1*
	            sys-libs/libraw1394 )
	test? ( net-misc/wget )
	x264? ( media-libs/x264-svn )
	faad? (  media-libs/faad2 )
	xvid? ( media-libs/xvid )
	"
src_unpack() {
	subversion_src_unpack
	cd ${S}
}

src_compile() {
	filter-flags -fforce-addr -momit-leaf-frame-pointer
	local myconf=""
	if use "swscaler"; then 
		myconf="${myconf} --enable-swscaler"
	fi
	if use "avisynth"; then 
		myconf="${myconf} --enable-avisynth"
	fi
	if ! use "altivec"; then 
		myconf="${myconf} --disable-altivec"
	fi
	if ! use "network"; then 
		myconf="${myconf}  --disable-protocols --disable-ipv6 --disable-network --disable-ffserver"
	fi
	if use "faac"; then 
		myconf="${myconf} --enable-faac"
	fi
	if use "faad"; then 
		myconf="${myconf} --enable-faad"
	fi
	if use "threads"; then 
		myconf="${myconf} --enable-pthreads"
	fi
	if use "pp"; then 
		myconf="${myconf} --enable-pp"
	fi
	if use "a52"; then 
		myconf="${myconf} --enable-a52"
	fi
	if use "gpl"; then 
		myconf="${myconf} --enable-gpl"
	fi
	if use "mp3"; then 
		myconf="${myconf} --enable-mp3lame"
	fi
	if ! use "opts"; then 
		myconf="${myconf} --disable-opts"
	fi
	if use "ogg"; then 
		myconf="${myconf} --enable-libogg"
	fi
	if use "vorbis"; then 
		myconf="${myconf} --enable-vorbis"
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

	./configure --prefix=/usr \
	--mandir=/usr/share/man   \
	--disable-static --enable-shared  ${myconf} || die "Configure failed"

	# custom version hook
	FFMPEG_VERSION=$(LC_ALL=C svn info \
	${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/${PN}/trunk | \
	grep    Revision|sed    -re "s/.*:\s*//g" )
	FFMPEG_VERSION="\"dev-SVN-r$MPLAYER_VERSION "
	FFMPEG_VERSION="$FFMPEG_VERSION built on $(date "+%Y-%m-%d %H:%m") \""
	einfo "FFMpeg version set to:  $FFMPEG_VERSION"
	FFMPEG_VERSION="#define VERSION $FFMPEG_VERSION"
	echo "$FFMPEG_VERSION" > version.h


	emake CC="$(tc-getCC)" || die "static failed"
}

src_install() {
	addpredict "/usr"
	addpredict "/usr/lib"
	use doc && make documentation
	
	 cd ${S}
	make DESTDIR="${D}" install  || die "Install Failed"



	dodoc ChangeLog README INSTALL
	dodoc doc/*
	#cd libavcodec/libpostproc
	#make install || die "Failed to install libpostproc.a!"
	# Some stuff like transcode can use this one.
	#dolib ${S}/libavcodec/libpostproc/libpostproc.a
	#preplib /usr
}


