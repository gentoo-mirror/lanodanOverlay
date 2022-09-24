# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Alternative rust compiler (re-implementation)"
HOMEPAGE="https://github.com/thepowersgang/mrustc"
SRC_URI="https://github.com/thepowersgang/mrustc/archive/refs/tags/v0.10.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPENDS="sys-libs/zlib:="
DOCS=( docs/ Notes/ README.md )

src_prepare() {
	default

	sed -i \
		-e 's/\$(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)/v${PV}/' \
		-e 's/\$(shell git diff-index --quiet HEAD; echo $$?)/0/' \
		Makefile || die

	sed -i '/objcopy --only-keep-debug/,/strip/d' Makefile || die
}

src_install() {
	einstalldocs
	dobin bin/mrustc
}
