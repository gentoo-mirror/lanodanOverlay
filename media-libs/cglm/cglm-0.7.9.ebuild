# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="OpenGL Mathematics (glm) for C"
HOMEPAGE="https://github.com/recp/cglm"
SRC_URI="https://github.com/recp/cglm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	default
	eautoreconf
}
