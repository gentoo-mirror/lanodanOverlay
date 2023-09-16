# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="JSON.parse with context information on error"
HOMEPAGE="https://github.com/npm/json-parse-even-better-errors"
SRC_URI="https://github.com/npm/json-parse-even-better-errors/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap )"

RESTRICT="test"
