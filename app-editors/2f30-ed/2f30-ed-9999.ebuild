# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="simple ed"
HOMEPAGE="http://git.2f30.org/ed"
EGIT_REPO_URI="git://git.2f30.org/ed.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
cc ed.c -o 2f30-ed
}

src_install() {
dobin 2f30-ed
}
