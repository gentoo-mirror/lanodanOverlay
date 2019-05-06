# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/wio"
else
	KEYWORDS="~amd64"
fi

DESCRIPTION="Wayland Kiosk"
HOMEPAGE="https://wio-project.org/"
LICENSE="BSD"
SLOT="0"
IUSE=""

# dev-libs/wayland provides wayland-server
DEPEND="
	>=gui-libs/wlroots-0.6.0:=
	x11-libs/cairo:=
	dev-libs/wayland-protocols:=
	x11-libs/libxkbcommon:=
	dev-libs/wayland:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		"-Dwerror=false"
	)

	meson_src_configure
}
