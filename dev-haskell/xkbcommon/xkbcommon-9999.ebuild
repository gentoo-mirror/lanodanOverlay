# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib"

inherit haskell-cabal git-r3

DESCRIPTION="Haskell bindings for libxkbcommon (Waymonad)"
HOMEPAGE="https://github.com/Ongy/haskell-xkbcommon"
EGIT_REPO_URI="https://github.com/Ongy/haskell-xkbcommon.git"
EGIT_SUBMODULES=()
SLOT="0"
LICENSE="BSD MIT"
IUSE="test"

# Shipped in GHC: bytestring, filepath, process, template-haskell, time, unix
DEPEND="
	dev-haskell/transformers
	dev-haskell/storable-record
	dev-haskell/cpphs
	dev-haskell/text
	dev-haskell/data-flags

	dev-haskell/c2hs
	x11-libs/libxkbcommon

	test? (
		dev-haskell/random
		dev-haskell/vector
	)
"
