# Copyright 2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_12 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 optfeature

DESCRIPTION="Count hits per autonomous system number (ASN) and related network blocks"
HOMEPAGE="https://gitlab.com/anarcat/asncounter"
SRC_URI="https://gitlab.com/anarcat/asncounter/-/archive/${PV}/${P}.tar.gz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/pyasn
"
DEPEND="${RDEPEND}"
BDEPEND="app-text/lowdown"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	epytest -k 'not test_prometheus_record'
}

src_install() {
	distutils-r1_src_install

	lowdown -o asncounter.1 -s -t man asncounter.1.md || die
	doman asncounter.1
}

pkg_postinst() {
	optfeature "To get a debugging socket" dev-python/manhole
	optfeature "To scrape packets directly without tcpdump (slower)" net-analyzer/scapy
	optfeature "To export Prometheus metrics" dev-python/prometheus-client
	optfeature "To aggregate network blocks in the REPL or manhole" dev-python/netaddr
}
