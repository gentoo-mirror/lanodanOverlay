# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="https://www.teeworlds.com/"
SRC_URI="https://github.com/teeworlds/teeworlds/releases/download/${PV}/${P}-src.tar.gz"
# License of stuff in src/engine/external (* disabled)
# json-parser: BSD-2
# md5: ZLIB
# pnglite*: ZLIB
# wavpack*: BSD
# zlib*: ZLIB
LICENSE="ZLIB CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated test"
S="${WORKDIR}/${P}-src"

DEPEND="
	dev-lang/python
	sys-libs/zlib:=
	virtual/opengl:=
	!dedicated? (
		media-libs/freetype:=
		media-libs/libsdl2:=
		media-libs/pnglite:=
		media-sound/wavpack:=
		x11-libs/libX11:=
	)
	dev-libs/openssl:=
	test? ( dev-cpp/gtest )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDOWNLOAD_GTEST=OFF
		-DDOWNLOAD_DEPENDENCIES=OFF
		-DPREFER_BUNDLED_LIBS=OFF
		-DCLIENT=$(usex !dedicated)
	)

	cmake-utils_src_configure
}
