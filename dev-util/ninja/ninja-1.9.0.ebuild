# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fake virtual ebuild to allow dev-util/samurai"
SLOT="virtual"
KEYWORDS="~amd64"
ISUE="samurai"
RDEPEND="
	samurai ( dev-util/samurai )
	!samurai ( dev-util/ninja:0 )
"

src_install() {
	use samurai && dosym samu /usr/bin/ninja
}
