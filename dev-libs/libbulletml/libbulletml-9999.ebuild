# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs git-r3

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="https://hacktivis.me/git/libbulletml https://shinh.skr.jp/libbulletml/index_en.html"
EGIT_REPO_URI="https://anongit.hacktivis.me/git/libbulletml.git"
S="${WORKDIR}/${P}/src"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=""
RDEPEND=${DEPEND}

src_configure() {
	tc-export AR CXX
}

src_install() {
	dolib.a libbulletml.a

	insinto /usr/include/bulletml
	doins *.h

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h

	dodoc ../README*
}
