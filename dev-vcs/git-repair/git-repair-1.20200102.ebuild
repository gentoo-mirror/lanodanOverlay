# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="haddock hoogle profile"
inherit haskell-cabal

DESCRIPTION="repairs a damanged git repisitory"
HOMEPAGE="https://git-repair.branchable.com/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
ISUE=""

RDEPEND="
	dev-haskell/async:=[profile?]
	dev-haskell/attoparsec:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/exceptions-0.6:=[profile?]
	>=dev-haskell/filepath-bytestring-1.4.2.1.0:=[profile?]
	dev-haskell/hslogger:=[profile?]
	dev-haskell/ifelse:=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/network:=[profile?]
	dev-haskell/network-uri:=[profile?]
	>=dev-haskell/optparse-applicative-0.14.1:=[profile?]
	dev-haskell/quickcheck:=[profile?]
	dev-haskell/setenv:=[profile?]
	dev-haskell/split:=[profile?]
	dev-haskell/text:=[profile?]
	>=dev-haskell/unix-compat-0.5:=[profile?]
	dev-haskell/utf8-string:=[profile?]
"
DEPEND="${RDEPEND}"
