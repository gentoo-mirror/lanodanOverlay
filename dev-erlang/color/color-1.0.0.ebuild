# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="erlang-color-${PV}"

inherit rebar3

DESCRIPTION="ANSI colors for your Erlang"
HOMEPAGE="https://github.com/julianduque/erlang-color"
SRC_URI="https://github.com/julianduque/erlang-color/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/"

# src/color.app.src
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DOCS=( README.md )
