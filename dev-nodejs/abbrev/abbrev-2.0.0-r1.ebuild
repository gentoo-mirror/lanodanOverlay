# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Get unique abbreviations for a set of strings"
HOMEPAGE="https://github.com/npm/abbrev-js"
SRC_URI="https://github.com/npm/abbrev-js/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/abbrev-js-${PV}"
LICENSE="ISC" # ISC OR MIT
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

PATCHES=(
	"${FILESDIR}/abbrev-2.0.0-node_test.patch"
)
