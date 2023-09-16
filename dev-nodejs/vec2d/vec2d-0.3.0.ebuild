# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="2d vector math with good unit tests"
HOMEPAGE="https://github.com/andrewrk/node-vec2d"
SRC_URI="https://github.com/andrewrk/node-vec2d/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-vec2d-${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"
# BDEPEND="test? ( dev-nodejs/mocha )"
