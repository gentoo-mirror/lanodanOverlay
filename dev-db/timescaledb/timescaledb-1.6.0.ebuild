# Copyright 1999-2018 Gentoo Authors
# Copyright 2018-2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.6 10 12 )
POSTGRES_USEDEP="server"

inherit postgres-multi

DESCRIPTION="A time-series database optimized for fast ingest and complex queries"
HOMEPAGE="https://www.timescale.com/"
SRC_URI="https://github.com/timescale/${PN}/releases/download/${PV}/${P}.tar.lzma"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs"
KEYWORDS="~amd64 ~x86"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	postgres-multi_src_prepare
}
src_configure() {
	postgres-multi_foreach cmake-utils_src_configure
}

src_compile() {
	postgres-multi_foreach cmake-utils_src_compile
}

src_install() {
	postgres-multi_foreach cmake-utils_src_install

	use static-libs || find "${ED}" -name '*.a' -delete
}
