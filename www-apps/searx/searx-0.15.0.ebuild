# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit distutils-r1

DESCRIPTION="Decentralized and privacy-respecting, hackable metasearch engine"
HOMEPAGE="https://github.com/asciimoo/searx https://searx.me"
SRC_URI="https://github.com/asciimoo/searx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/certifi-2017.11.5
	>=dev-python/flask-1.0.2
	>=dev-python/flask-babel-0.11.2
	>=dev-python/lxml-4.2.3
	>=dev-python/idna-2.7
	>=dev-python/pygments-2.1.3
	>=dev-python/pyopenssl-18.0.0
	>=dev-python/python-dateutil-2.7.3
	>=dev-python/pyyaml-3.13
	>=dev-python/requests-2.19.1[socks5]
"
RDEPEND="${DEPEND}"
