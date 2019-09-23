# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

DESCRIPTION="FreeDesktop.Org backend for WPE WebKit"
HOMEPAGE="https://wpewebkit.org/"
LICENSE="BSD-2"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"
SLOT="1.0" # WPE_API_VERSION
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

# documentation depends on hotdoc
DEPEND="
	media-libs/mesa[egl]
	dev-libs/glib:=
	>=dev-libs/wayland-1.10:=
	net-libs/libwpe:=
"
RDEPEND="${DEPEND}"
