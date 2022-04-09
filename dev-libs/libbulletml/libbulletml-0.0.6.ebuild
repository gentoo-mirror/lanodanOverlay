# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="https://shinh.skr.jp/libbulletml/index_en.html"
SRC_URI="
	https://shinh.skr.jp/libbulletml/${P}.tar.bz2
	https://deb.debian.org/debian/pool/main/b/bulletml/bulletml_0.0.6-7.debian.tar.xz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=""
RDEPEND=${DEPEND}

# debian/patches/includes.patch is equivalent to ${P}-gcc43.patch
PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

DEB_PATCHES=(
	"${WORKDIR}/debian/patches/fixes.patch"
	"${WORKDIR}/debian/patches/bulletml_d.patch"
	"${WORKDIR}/debian/patches/includes.patch"
	"${WORKDIR}/debian/patches/get-rid-of-boost.patch"
)

S="${WORKDIR}"/${PN#lib}/src

src_prepare() {
	default

	rm -r boost || die

	eapply -p2 "${DEB_PATCHES[@]}"
}

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
