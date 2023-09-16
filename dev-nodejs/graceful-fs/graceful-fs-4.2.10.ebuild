# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="drop-in replacement for fs, making various improvements"
HOMEPAGE="https://github.com/isaacs/node-graceful-fs"
SRC_URI="https://github.com/isaacs/node-graceful-fs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/node-${P}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/import-fresh
#	dev-nodejs/mkdirp
#	dev-nodejs/rimraf
#	dev-nodejs/tap
#)"

RESTRICT="test"
