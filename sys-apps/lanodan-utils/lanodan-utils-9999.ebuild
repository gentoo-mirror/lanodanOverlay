# Copyright 2021-2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of Unix tools, comparable to coreutils"
HOMEPAGE="https://hacktivis.me/git/utils"
EGIT_REPO_URI="https://hacktivis.me/git/utils.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="suspend test"

RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

src_configure() {
	export NO_BWRAP=1

	./configure PREFIX='/opt/lanodan'
}

src_install() {
	emake install DESTDIR="${D}"

	if use !suspend; then
		rm "${D}/opt/lanodan/sbin/memsys" || die "Failed removing memsys"
	fi

	# before 50baselayout
	newenvd - 40lanodan <<-EOF
		PATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		ROOTPATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		MANPATH="/opt/lanodan/share/man"
	EOF
}
