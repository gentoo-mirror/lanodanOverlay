# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/hoedown/hoedown/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Standards compliant, fast, secure markdown processing library in C"
HOMEPAGE="https://github.com/hoedown/hoedown"

LICENSE="ISC"
SLOT="0"
IUSE="test"

RDEPEND="!dev-python/smartypants"
DEPEND="
	${RDEPEND}
	test? ( app-text/htmltidy )
"

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}"
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBDIR=/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install
	einstalldocs
}
