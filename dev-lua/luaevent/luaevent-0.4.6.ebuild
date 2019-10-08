# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit lua

DESCRIPTION="libevent bindings for Lua"
HOMEPAGE="http://luaforge.net/projects/luaevent/"
SRC_URI="https://github.com/harningt/luaevent/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-libs/libevent:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(README)

each_lua_install() {
	dolua lua/*
	_dolua_insdir="${PN}" \
	dolua core.so
}
