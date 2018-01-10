# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="An open-source full-featured 2D animation creation software"
HOMEPAGE="https://opentoonz.github.io/"
SRC_URI="https://github.com/opentoonz/opentoonz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD CC0-1.0 libtiff"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="system-lzo system-superlu"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.55.0:=
	dev-libs/lzo:2=
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/freeglut:=
	media-libs/freetype:2=
	media-libs/glew:=
	media-libs/libmypaint
	media-libs/libpng:=
	media-libs/libsdl2:=
	sci-libs/superlu:=
	virtual/libusb:1=
"
DEPEND="${RDEPEND}"

CMAKE_USE_DIR="${S}"/toonz/sources

src_configure() {
	local mycmakeargs=(
		-DTIFF_LIBRARY="${S}/thirdparty/tiff-4.0.3/libtiff/.libs/libtiff.a"
		-DWITH_SYSTEM_LZO=ON
		-DWITH_SYSTEM_SUPERLU=ON
		-DCMAKE_SKIP_RPATH=ON
	)

	# The upstream uses their own modified libtiff
	# See: https://github.com/opentoonz/opentoonz/blob/master/doc/how_to_build_linux.md#building-libtiff
	-DCMAKE_SKIP_RPATH=ON
	cd thirdparty/tiff-4.0.3 || die
	econf \
		--with-pic \
		--disable-jbig \
		--enable-static \
		--disable-shared

	cmake-utils_src_configure
}

src_compile() {
	cd "${S}"/thirdparty/tiff-4.0.3 || die
	emake

	cmake-utils_src_compile
}

pkg_postinst() {
	elog "It is supposedly optional but some files are"
	elog "actually required to run the executable properly."
	elog
	elog "The .config/OpenToonz/ directory in your home folder"
	elog "will contain your settings, work and other files."
	elog
	elog "We need to create it from the command-line:"
	elog
	elog "$ mkdir -p \$HOME/.config/OpenToonz"
	elog "$ cp -r /usr/share/opentoonz/stuff/ \$HOME/.config/OpenToonz/"
}
