# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar3

DESCRIPTION="Mocking library for Erlang"
HOMEPAGE="https://github.com/eproxus/meck"
SRC_URI="https://github.com/eproxus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	>=dev-lang/erlang-17.1
	test? ( dev-erlang/unite )
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md NOTICE README.md )

src_prepare() {
	rebar3_src_prepare

	sed -i 's;{deps, \[unite\]},;{deps, []},;' rebar.config || die
}
