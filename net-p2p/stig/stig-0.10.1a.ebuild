# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="TUI and CLI for the BitTorrent client Transmission"
HOMEPAGE="https://github.com/rndusr/stig"
SRC_URI="https://github.com/rndusr/stig/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="geoip test"

RDEPEND="
	>=dev-python/urwid-2.0
	>=dev-python/urwidtrees-1.0.2
	dev-python/aiohttp
	dev-python/async_timeout
	dev-python/pyxdg
	dev-python/blinker
	dev-python/natsort
	geoip? ( dev-python/maxminddb )
	dev-python/setproctitle
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/asynctest )
"

src_prepare() {
	# Taken from Void Linux
	sed -i 's/urwidtrees>=1.0.3dev0/urwidtrees>=1.0.2/' setup.py || die

	distutils-r1_src_prepare
}
