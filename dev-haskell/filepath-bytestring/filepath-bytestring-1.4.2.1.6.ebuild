# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="haddock hoogle profile lib"
inherit haskell-cabal

DESCRIPTION="repairs a damanged git repisitory"
HOMEPAGE="http://hackage.haskell.org/package/filepath-bytestring"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
ISUE=""

RDEPEND="
	dev-haskell/utf8-string:=[profile?]
"
DEPEND="${RDEPEND}"
