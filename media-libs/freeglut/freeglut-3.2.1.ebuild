# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="A free OpenGL utility toolkit, the open-sourced alternative to the GLUT library"
HOMEPAGE="http://freeglut.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug static-libs wayland-only"

RDEPEND="!wayland-only? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
	)
	wayland-only? (
		media-libs/mesa[egl,gles1,gles2,${MULTILIB_USEDEP}]
		dev-libs/wayland[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	!wayland-only? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-3.2.1-gcc10-fno-common.patch )
HTML_DOCS=( doc/. )

src_configure() {
	local mycmakeargs=(
		"-DFREEGLUT_BUILD_DEMOS=OFF"
		"-DFREEGLUT_BUILD_STATIC_LIBS=$(usex static-libs ON OFF)"
		"-DFREEGLUT_WAYLAND=$(usex wayland-only )"
		"-DFREEGLUT_GLES=$(usex wayland-only )"
	)
	cmake-multilib_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	cp "${D}"/usr/$(get_libdir)/pkgconfig/{,free}glut.pc
}