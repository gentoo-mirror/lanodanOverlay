# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="replacement for process.exit that ensures stdio are fully drained before exiting"
HOMEPAGE="https://github.com/cowboy/node-exit"
SRC_URI="https://github.com/cowboy/node-exit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-${P}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"
#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/grunt-contrib-jshint
#	dev-nodejs/grunt-contrib-nodeunit
#	dev-nodejs/grunt-contrib-watch
#	dev-nodejs/grunt
#	dev-nodejs/which
#)"

RESTRICT="test"
