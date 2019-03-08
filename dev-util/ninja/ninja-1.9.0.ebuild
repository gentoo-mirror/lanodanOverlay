# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fake virtual ebuild to allow dev-util/samurai"
LICENSE="public-domain"
SLOT="virtual"
KEYWORDS="~amd64"
IUSE="samurai"
RDEPEND="
	samurai? (
		dev-util/samurai
		!dev-util/ninja:0
	)
	!samurai? ( dev-util/ninja:0 )
"

S="${WORKDIR}"

src_install() {
	use samurai && dosym samu /usr/bin/ninja
}
