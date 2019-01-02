# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Dreamcast Emulator"
HOMEPAGE="http://reicast.com/"
LICENSE="GPL-2"
SRC_URI="https://github.com/reicast/reicast-emulator/archive/r${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/alsa-lib
	media-libs/mesa[egl,gles2]
	dev-python/python-evdev
"

S="${WORKDIR}/reicast-emulator-r${PV}/shell/linux"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
