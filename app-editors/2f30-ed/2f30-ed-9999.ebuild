# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Simple ed(1) implementation from 2f30.org"
HOMEPAGE="https://git.2f30.org/ed"
EGIT_REPO_URI="git://git.2f30.org/ed.git"

LICENSE="MIT"
SLOT="0"

src_compile() {
	${CC:-cc} ed.c -o 2f30-ed || die
}

src_install() {
	dobin 2f30-ed
}
