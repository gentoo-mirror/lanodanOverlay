# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit haskell-cabal

DESCRIPTION="A Base91 Encoder & Decoder for Haskell"
HOMEPAGE="https://github.com/ajg/base91"
SRC_URI="https://github.com/ajg/base91/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-haskell/mono-traversable"
RDEPEND="${DEPEND}"
