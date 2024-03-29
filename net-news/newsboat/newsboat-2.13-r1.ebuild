# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An RSS/Atom feed reader for text terminals"
HOMEPAGE="https://newsboat.org/ https://github.com/newsboat/newsboat"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://newsboat.org/releases/${PV}/${P}.tar.xz"
LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.18.0
	>=dev-libs/json-c-0.11:=
	dev-libs/libxml2
	sys-libs/ncurses:0=[unicode(+)]
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.11-flags.patch
	"${FILESDIR}"/${PN}-2.13-json-c-0.14.0.patch
)

src_configure() {
	./config.sh || die
}

src_compile() {
	emake prefix="/usr" CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	# tests require UTF-8 locale
	emake CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" test
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test || die
	./test || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" docdir="/usr/share/doc/${PF}" install
	dodoc CHANGELOG.md README.md TODO
}
