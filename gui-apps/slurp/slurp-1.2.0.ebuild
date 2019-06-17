# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Select a region in a Wayland compositor and print it to stdout"
HOMEPAGE="https://wayland.emersion.fr/slurp"
SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/cairo:=
	dev-libs/wayland:=
"

DEPEND="
	${DEPEND}
	app-text/scdoc
"

src_configure() {
	local emesonargs=(
		"-Dwerror=false"
	)

	meson_src_configure
}
