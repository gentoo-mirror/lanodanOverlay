# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="parse argument options"
HOMEPAGE="https://github.com/minimistjs/minimist"
SRC_URI="https://github.com/minimistjs/minimist/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"
DEPEND="test? ( dev-nodejs/tape-lite )"

src_prepare() {
	default

	sed -i "s;require('tape');require('tape-lite');;" test/*.js || die
}

src_test() {
	node --test test/*.js || die
}
