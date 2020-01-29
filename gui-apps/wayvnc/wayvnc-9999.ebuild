# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="VNC server for wlroots based Wayland compositors"
HOMEPAGE="https://github.com/any1/wayvnc"
EGIT_REPO_URI="https://github.com/any1/wayvnc.git"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls jpeg"

DEPEND="
	media-libs/mesa:=
	dev-libs/libuv:=
	x11-libs/libxkbcommon:=
	net-misc/neatvnc:=
	x11-libs/pixman:=
"
RDEPEND="${DEPEND}"
