# Copyright 1999-2016 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true

inherit lua

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication."
HOMEPAGE="http://www.inf.puc-rio.br/~brunoos/luasec/"
SRC_URI="https://github.com/brunoos/luasec/archive/${P}.tar.gz"
LUA_S="${PN}-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples"

RDEPEND="
	dev-lua/luasocket
	dev-libs/openssl
"
DEPEND="
	${RDEPEND}
"

all_lua_prepare() {
	sed -i -r \
		-e 's#(MAKE\)).*(install)#\1 \2#' \
		-e '/LIB_PATH.*-L.usr.lib/d' \
		Makefile

	pushd src &>/dev/null
	lua_default
	popd &>/dev/null
}

each_lua_configure() {
	pushd src &>/dev/null
	myeconfargs=()
	myeconfargs+=(
		LD='$(CC)'
		LUAPATH="$(lua_get_pkgvar INSTALL_LMOD)"
		LUACPATH="$(lua_get_pkgvar INSTALL_CMOD)"
	)

	lua_default
	popd &>/dev/null
}

each_lua_compile() {
	lua_default linux
}
