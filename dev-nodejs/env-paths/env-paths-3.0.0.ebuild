# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Get paths for storing things like data, config, cache, etc"
HOMEPAGE="https://github.com/sindresorhus/env-paths"
SRC_URI="https://github.com/sindresorhus/env-paths/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/ava
#	dev-nodejs/tsd
#	dev-nodejs/xo
#)"

RESTRICT="test"
