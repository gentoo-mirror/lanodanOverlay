# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Add callbacks to requests in flight to avoid async duplication"
HOMEPAGE="https://github.com/npm/inflight"
SRC_URI="https://github.com/npm/inflight/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap )"

RESTRICT="test"
