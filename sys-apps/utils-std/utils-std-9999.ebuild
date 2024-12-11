# Copyright 2021-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of commonly available Unix tools"
HOMEPAGE="https://hacktivis.me/git/utils-std"
EGIT_REPO_URI="https://anongit.hacktivis.me/git/utils-std.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test static system"

RESTRICT="!test? ( test )"

RDEPEND="
	system? (
		!sys-apps/coreutils[system(+)]
		!sys-apps/diffutils[system(+)]
	)
"
BDEPEND="
	app-alternatives/yacc
	test? ( dev-util/cram )
"

src_configure() {
	export NO_BWRAP=1

	use static && export LDSTATIC="-static-pie"

	./configure PREFIX=$(usex system '/usr' '/opt/lanodan')
}

src_install() {
	emake install DESTDIR="${D}"

	# before 50baselayout
	use system || newenvd - 40lanodan <<-EOF
		PATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		ROOTPATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		MANPATH="/opt/lanodan/share/man"
	EOF
}
