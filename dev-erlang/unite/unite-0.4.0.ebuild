# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar3

DESCRIPTION="Pretty EUnit test formatters"
HOMEPAGE="https://github.com/eproxus/meck"
SRC_URI="https://github.com/eproxus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	>=dev-erlang/color-1.0.0
	>=dev-erlang/tdiff-0.1.2
"
RDEPEND="${DEPEND}"

# uses ex_doc
DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rebar3_src_prepare

	sed -i '/{project_plugins,/d' rebar.config || die
}
