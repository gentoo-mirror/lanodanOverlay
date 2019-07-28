# Copyright 1999-2015 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Fast and flexible Lua-based build system"
HOMEPAGE="https://matricks.github.com/bam/"
SRC_URI="https://github.com/matricks/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-lang/lua:="
DEPEND="${RDEPEND}"
