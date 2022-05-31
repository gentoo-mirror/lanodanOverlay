# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw-legacy/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/glfw-legacy-${PV}"

LICENSE="ZLIB"
SLOT="2"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~hppa ~ppc64"
IUSE=""

RDEPEND="
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXinerama[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	x11-libs/libXi[${MULTILIB_USEDEP}]
"

src_prepare() {
	sed -i 's;$(PREFIX)/;$(DESTDIR)$(PREFIX)/;' lib/x11/Makefile.x11.in || die

	default

	multilib_copy_sources
}

multilib_src_configure() {
	sed -i 's;$(PREFIX)/lib;$(PREFIX)/'"$(get_libdir);" lib/x11/Makefile.x11.in || die

	sh "${S}/compile.sh" || die
}

multilib_src_compile() {
	export PREFIX="/usr"

	emake x11 AR="$(tc-getAR)"
}

multilib_src_install() {
	emake -j1 DESTDIR="${ED}" x11-install x11-dist-install
}
