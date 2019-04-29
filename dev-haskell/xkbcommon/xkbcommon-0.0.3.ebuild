# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib"

inherit haskell-cabal

DESCRIPTION="Haskell bindings for libxkbcommon"
HOMEPAGE="https://github.com/tulcod/haskell-xkbcommon"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"
SLOT="0"
LICENSE="BSD MIT"
KEYWORDS="~amd64"

# Shipped in GHC: bytestring, filepath, process, template-haskell
DEPEND="
	dev-haskell/cpphs
	dev-haskell/data-flags
	dev-haskell/storable-record
	dev-haskell/text
	dev-haskell/transformers
"
