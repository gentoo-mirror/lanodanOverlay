# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )
inherit lua-single

DESCRIPTION="GENie project generator tool (a fork of premake by Branimir Karadžić)"
HOMEPAGE="https://github.com/bkaradzic/GENie"

# No proper release/tag tarballs
EGIT_COMMIT="81e594dc974866b5d301711258c774cbf3c68883"
SRC_URI="https://github.com/bkaradzic/GENie/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/GENie-${EGIT_COMMIT}/"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "docs/scripting-reference.md" )

PATCHES=( "${FILESDIR}/genie-1170-system-lua.patch" )

src_prepare() {
	default

	sed -i \
		-e 's;^CC\W*=.*;CC ?= cc;' \
		-e 's;^CXX\W*=.*;CXX ?= c++;' \
		-e 's;^AR\W*=.*;AR ?= ar;' \
		build/gmake.linux/genie.make || die

	rm -r src/host/lua-5.3.0 || die
}

src_compile() {
	emake verbose=1 SILENT='' ARCH=''
}

src_install() {
	dobin bin/linux/genie
}
