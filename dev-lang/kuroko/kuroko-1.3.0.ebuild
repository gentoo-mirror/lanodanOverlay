# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dynamic, bytecode-compiled programming language and a dialect of Python"
HOMEPAGE="https://kuroko-lang.github.io/"
SRC_URI="https://github.com/kuroko-lang/kuroko/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	export prefix=/usr
	default
}
