# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.1"
PYTHON_COMPAT=( python3_{7..11} )

inherit git-r3 cmake python-single-r1 wxwidgets xdg

DESCRIPTION="easy-to-use, cross-platform multi-track audio editor/recorder"
HOMEPAGE="https://tenacityaudio.org/"
EGIT_REPO_URI="https://github.com/tenacityteam/tenacity.git"
EGIT_SUBMODULES=()
# GPL-2: Tenacity code
# CC-BY-3.0: Tenacity Documentation
# CC-BY-4.0: Audacity Logo
# Nyquist: BSD-style license for ./lib-src/libnyquist
# BSD: ./lib-src/libnyquist/xlisp
LICENSE="GPL-2 CC-BY-3.0 CC-BY-4.0 Nyquist BSD"
SLOT="0"

IUSE="+midi id3tag mp3 ogg +vorbis +flac sbsms soundtouch ffmpeg +lv2 twolame +vst2 vamp"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# vst2 dep on GTK+3[X]: https://github.com/tenacityteam/tenacity/issues/614
RDEPEND="
	${PYTHON_DEPS}
	virtual/opengl
	sys-libs/zlib:=
	dev-libs/expat
	media-sound/lame
	media-libs/libsndfile
	media-libs/soxr
	dev-db/sqlite:3
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}
	midi? (
		media-libs/portmidi:=
		media-libs/portsmf:=
	)
	id3tag? ( media-libs/libid3tag:= )
	mp3? ( media-libs/libmad )
	twolame? ( media-sound/twolame )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac:=[cxx] )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( media-libs/libsoundtouch:= )
	ffmpeg? ( media-video/ffmpeg:= )
	lv2? (
		media-libs/lv2
		media-libs/lilv
		media-libs/suil
	)
	vamp? ( media-libs/vamp-plugin-sdk )
	vst2? ( x11-libs/gtk+:3[X] )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
	app-text/scdoc
"

# src/CMakeLists.txt already installs README.md
DOCS=()

src_prepare() {
	cmake_src_prepare

	sed -i 's;${_DATADIR}/doc/${AUDACITY_NAME};${_DATADIR}/doc/${PF};' \
		src/CMakeLists.txt || die
}

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DBUILD_MANPAGE=ON
		-DMIDI=$(usex midi)
		-DID3TAG=$(usex id3tag)
		-DMP3_DECODING=$(usex mp3)
		-DMP2_ENCODING=$(usex twolame)
		-DOGG=$(usex ogg)
		-DVORBIS=$(usex vorbis)
		-DFLAC=$(usex flac)
		-DSBSMS=$(usex sbsms)
		-DSOUNDTOUCH=$(usex soundtouch)
		-DFFMPEG=$(usex ffmpeg)
		-DVAMP=$(usex vamp)
		-DLV2=$(usex lv2)
		-DVST2=$(usex vst2)
	)

	cmake_src_configure
}
