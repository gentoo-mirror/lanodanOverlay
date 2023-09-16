# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Minimal module to check if a file is executable"
HOMEPAGE="https://github.com/isaacs/isexe"
SRC_URI="https://github.com/isaacs/isexe/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

#IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/tap
#	dev-nodejs/mkdirp
#	dev-nodejs/rimraf
#)"

RESTRICT="test"
