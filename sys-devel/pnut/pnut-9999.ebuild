# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Self-Compiling C Transpiler Targeting Human-Readable POSIX Shell"
HOMEPAGE="https://pnut.sh/"
EGIT_REPO_URI="https://github.com/udem-dlteam/pnut"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default

	sed -i 's;gcc;$(CC);' Makefile || die
}

src_install() {
	einstalldocs
	newbin build/pnut-sh pnut
	dobin build/pnut.sh
}
