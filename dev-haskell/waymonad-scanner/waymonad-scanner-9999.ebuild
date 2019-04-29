# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib"

inherit haskell-cabal git-r3

DESCRIPTION="Haskell bindings for libxkbcommon"
HOMEPAGE="https://github.com/waymonad/waymonad-scanner"
EGIT_REPO_URI="https://github.com/waymonad/waymonad-scanner.git"
EGIT_SUBMODULES=()
SLOT="0"
LICENSE="LGPL-2.1"

# Shipped in GHC: containers, bytestring, process, template-haskell
DEPEND="
	dev-haskell/mtl
	dev-haskell/cereal
	dev-haskell/text
	dev-haskell/hayland
	dev-haskell/xml
	dev-haskell/hsroots
"
