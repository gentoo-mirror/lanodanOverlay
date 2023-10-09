# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Match balanced character pairs, like { and }"
HOMEPAGE="https://github.com/juliangruber/balanced-match"
SRC_URI="https://github.com/juliangruber/balanced-match/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? (
#	dev-nodejs/at_c4312_matcha
#	dev-nodejs/np
#	dev-nodejs/prettier-standard
#	dev-nodejs/standard
#	dev-nodejs/tape
#)"

RESTRICT="test"
