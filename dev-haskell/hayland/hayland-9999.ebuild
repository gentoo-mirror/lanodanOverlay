# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib"

inherit haskell-cabal git-r3

DESCRIPTION="Haskell bindings to Wayland library (Waymonad fork)"
HOMEPAGE="https://github.com/Ongy/haskell-wayland"
EGIT_REPO_URI="https://github.com/Ongy/haskell-wayland.git"
EGIT_SUBMODULES=()
SLOT="0"
LICENSE="MIT"

# Shipped in GHC: process, template-haskell, time
# Note: Build failed with =dev-haskell/c2hs-0.16.5::haskell, seems related to
#	https://github.com/haskell/c2hs/issues/192 so I upped the version
#	requirements of c2hs and language-c instead of copying from the cabal file.
DEPEND="
	dev-haskell/xml
	dev-haskell/data-flags
	dev-haskell/transformers
	>=dev-haskell/c2hs-0.28
	>=dev-haskell/language-c-0.7.0
	virtual/pkgconfig
"
RESTRICT="test" # Assumes weston is running
