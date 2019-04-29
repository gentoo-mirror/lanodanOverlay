# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib"

inherit haskell-cabal

DESCRIPTION="Bindings for the FUSE library"
HOMEPAGE="https://github.com/m15k/hfuse"
SRC_URI="https://github.com/m15k/hfuse/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"

# Shipped in GHC: base, unix, bytestring
