# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic git-r3 xdg-utils

DESCRIPTION="C++ user interface toolkit for X and OpenGL"
HOMEPAGE="https://www.fltk.org/"
EGIT_REPO_URI="https://github.com/fltk/fltk"

SLOT="1"
LICENSE="FLTK LGPL-2"
KEYWORDS=""
IUSE="cairo debug doc examples games +opengl static-libs +threads +wayland +X +xft +xinerama"

REQUIRED_USE="xinerama? ( X ) xft? ( X )"

RDEPEND="
	>=media-libs/libpng-1.2:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
	cairo? ( x11-libs/cairo[${MULTILIB_USEDEP},X] )
	games? ( !sys-block/blocks )
	opengl? (
		virtual/glu[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
	wayland? (
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
		x11-libs/pango
		dev-libs/wayland
		gui-libs/libdecor
		opengl? ( media-libs/glew:0 )
	)
	X? (
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXt[${MULTILIB_USEDEP}]
	)
	xft? ( x11-libs/libXft[${MULTILIB_USEDEP}] )
	xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	wayland? ( dev-libs/wayland-protocols )
	X? ( x11-base/xorg-proto )
	doc? ( app-doc/doxygen )
"
DOCS=(
	ANNOUNCEMENT
	CHANGES.txt
	CHANGES_1.0.txt
	CHANGES_1.1.txt
	CHANGES_1.3.txt
	CREDITS.txt
	README.Android.md
	README.CMake.txt
	README.Cairo.txt
	README.IDE.txt
	README.Pico.txt
	README.Unix.txt
	README.Windows.txt
	README.abi-version.txt
	README.bundled-libs.txt
	README.macOS.md
	README.md
	README.txt
)

pkg_setup() {
	unset FLTK_LIBDIRS
}

src_prepare() {
	rm -rf zlib jpeg png || die

	cmake_src_prepare
	multilib_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DOPTION_BUILD_SHARED_LIBS=ON
		-DOPTION_CAIRO=ON
		-DOPTION_CAIROEXT=ON
		-DOPTION_PANGO=ON
		-DOPTION_USE_SYSTEM_ZLIB=ON
		-DOPTION_USE_SYSTEM_LIBJPEG=ON
		-DOPTION_USE_SYSTEM_LIBPNG=ON
		-DOPTION_USE_SYSTEM_LIBDECOR=ON
		-DOPTION_USE_WAYLAND=$(usex wayland)
	)
	#	-DOpenGL_GL_PREFERENCE=GLVND

	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
