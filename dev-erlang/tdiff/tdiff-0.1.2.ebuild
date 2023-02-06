# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar3

DESCRIPTION="Difference library"
HOMEPAGE="https://github.com/tomas-abrahamsson/tdiff"
SRC_URI="https://github.com/tomas-abrahamsson/tdiff/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DOCS=( README.md )
