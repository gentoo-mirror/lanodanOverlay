# Copyright 2021-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of commonly available Unix tools"
HOMEPAGE="https://hacktivis.me/git/utils-std"
EGIT_REPO_URI="https://hacktivis.me/git/utils-std.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test static"

RESTRICT="!test? ( test )"

# atf is both needed as a library and a test framework
DEPEND="test? ( dev-libs/atf )"
BDEPEND="
	app-alternatives/yacc
	test? (
		dev-libs/atf
		dev-util/kyua
		dev-util/cram
	)
"

src_configure() {
	export NO_BWRAP=1

	use static && export CFLAGS="${CFLAGS} -static"

	./configure PREFIX='/opt/lanodan'
}

src_install() {
	emake install DESTDIR="${D}"

	# before 50baselayout
	newenvd - 40lanodan <<-EOF
		PATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		ROOTPATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		MANPATH="/opt/lanodan/share/man"
	EOF
}
