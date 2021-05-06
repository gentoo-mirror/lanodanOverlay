# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Collection of Unix tools, comparable to coreutils"
HOMEPAGE="https://hacktivis.me/git/utils"
EGIT_REPO_URI="https://hacktivis.me/git/utils.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="suspend"

src_install() {
	emake install DESTDIR="${D}" PREFIX=/opt/lanodan BINDIR=/opt/lanodan/bin MANDIR=/opt/lanodan/man

	if use !suspend; then
		rm "${D}/opt/lanodan/bin/memsys" || die "Failed removing memsys"
	fi

	newenvd - 60lanodan <<-EOF
		PATH="/opt/lanodan/bin"
		ROOTPATH="/opt/lanodan/bin"
		MANPATH="/opt/lanodan/man"
	EOF
}
