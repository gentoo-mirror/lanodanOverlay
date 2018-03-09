# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION="creates bindings for lua on c++"
HOMEPAGE="https://github.com/luabind/luabind"
SRC_URI="
	https://github.com/luabind/luabind/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://http.debian.net/debian/pool/main/l/luabind/luabind_0.9.1+dfsg-11.debian.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/lua"
RDEPEND="
	dev-util/boost-build:=
	${DEPEND}"

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/debian/patches" \
	EPATCH_SUFFIX="patch" \
		epatch

	default
}

src_compile() {
	#bjam release --prefix="${D}/usr/" link=shared toolset=gcc || die "compile failed"
	b2 release --prefix="${D}/usr/" link=static,shared || die "compile failed"
}

src_install() {
	#bjam release --prefix="${D}/usr/" link=shared toolset=gcc install || die "install failed"
	b2 release --prefix="${D}/usr/" link=static,shared install || die "install failed"
}
