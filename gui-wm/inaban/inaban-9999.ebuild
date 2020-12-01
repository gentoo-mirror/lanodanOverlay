# Copyright 2019-2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://hacktivis.me/git/inaban.git"
	EGIT_MIN_CLONE_TYPE="single+tags"
else
	KEYWORDS="~amd64"
fi

DESCRIPTION="Distrustful Tiling Wayland Compositor"
HOMEPAGE="https://hacktivis.me/git/inaban/"
LICENSE="BSD"
SLOT="0"
IUSE=""

# dev-libs/wayland provides wayland-server
DEPEND="
	>=gui-libs/wlroots-0.6.0:=
	dev-libs/wayland-protocols:=
	x11-libs/libxkbcommon:=
	dev-libs/wayland:=
"
RDEPEND="${DEPEND}"

src_configure() {
	restore_config config.h
	default
}

src_compile() {
	emake \
		CC="${CC:-cc}" \
		CFLAGS="${CFLAGS:--02 -Wall -Wextra}" \
		LDFLAGS="${LDFLAGS}" \
		PREFIX="/usr"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		install

	save_config config.h
	einstalldocs
}
