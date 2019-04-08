# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit haskell-cabal git-r3

DESCRIPTION="wayland compositor based on ideas from and inspired by xmonad"
HOMEPAGE="https://github.com/waymonad/waymonad"
EGIT_REPO_URI="https://github.com/waymonad/waymonad.git"
EGIT_SUBMODULES=()
SLOT="0"

# Shipped in GHC: containers, time, directory, unix, process, bytestring,
# deepseq, template-haskell, ghc-prim
DEPEND="
	dev-haskell/hsroots
	dev-haskell/hayland
	dev-haskell/clock
	dev-haskell/xkbcommon
	dev-haskell/composition
	dev-haskell/mtl
	dev-haskell/text
	dev-haskell/transformers
	dev-haskell/config-schema
	dev-haskell/config-value
	dev-haskell/xdg-basedir
	dev-haskell/network
	dev-haskell/data-default
	dev-haskell/semigroupoids
	dev-haskell/hfuse
	dev-haskell/formatting
	dev-haskell/stm
	dev-haskell/unliftio-core
	dev-haskell/unliftio
	dev-haskell/libinput
	dev-haskell/safe
	dev-haskell/waymonad-scanner
"
