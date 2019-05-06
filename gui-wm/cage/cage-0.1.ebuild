# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Wayland Kiosk"
HOMEPAGE="https://hjdskes.nl/projects/cage"
SRC_URI="https://github.com/Hjdskes/cage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="xwayland"

# dev-libs/wayland provides wayland-server, wayland-scanner
DEPEND="
	>=gui-libs/wlroots-0.5.0:=
	!>gui-libs/wlroots-0.6
	xwayland? ( gui-libs/wlroots[X] )
	>=dev-libs/wayland-protocols-1.14:=
	x11-libs/pixman:=
	x11-libs/libxkbcommon:=
	dev-libs/wayland:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		"$(meson_use xwayland)"
		"-Dwerror=false"
	)

	meson_src_configure
}
