# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The open source OpenXR runtime."
HOMEPAGE="https://monado.dev"
EGIT_REPO_URI="https://gitlab.freedesktop.org/monado/monado.git"
LICENSE="boost"
SLOT="0"

# TODO: OpenHMD
BDEPEND=""
DEPEND="
	media-libs/openxr-loader
	media-libs/mesa
	dev-cpp/eigen:3
	dev-util/glslang
	virtual/libusb
	virtual/libudev
	media-libs/libv4l
"
RDEPEND="${DEPEND}"

src_configure() {
	local ecmakeargs=(
		-DSYSTEM_CJSON=ON
	)

	cmake_src_configure
}
