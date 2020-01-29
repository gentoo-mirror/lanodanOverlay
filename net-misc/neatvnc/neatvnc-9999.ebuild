# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="liberally licensed VNC server library that's intended to be fast and neat"
HOMEPAGE="https://github.com/any1/neatvnc"
EGIT_REPO_URI="https://github.com/any1/neatvnc.git"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls jpeg"

DEPEND="
	x11-libs/pixman:=
	dev-libs/libuv:=
	gnutls? ( net-libs/gnutls:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
"
RDEPEND="
	${DEPEND}
	x11-libs/libdrm
"

src_configure() {
	local emesonargs=(
		$(meson_feature jpeg tight-encoding)
		$(meson_feature gnutls tls)
	)

	meson_src_configure
}
