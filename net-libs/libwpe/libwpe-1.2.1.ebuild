# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

DESCRIPTION="WebKit port optimized for embedded devices"
HOMEPAGE="https://wpewebkit.org/"
LICENSE="BSD-2"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"
SLOT="1.0" # WPE_API_VERSION
KEYWORDS="~amd64 ~arm"
IUSE=""

# documentation depends on hotdoc
RDEPEND="
	media-libs/mesa[egl]
	x11-libs/libxkbcommon:=
"
DEPEND="${RDEPEND}"
