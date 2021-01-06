# Copyright 2019-2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION=""
HOMEPAGE="https://github.com/hexpm/hex"
LICENSE="Apache-2.0"
SLOT="$(ver_cut 1-2)"
SRC_URI="https://github.com/hexpm/hex/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# Require >=elixir-1.5.0 because of the dependencies differencies between the two
DEPEND="
	test? (
		>=dev-lang/elixir-1.5.0
		=dev-elixir/stream_data-0.4.0
		=dev-elixir/plug-1.6.1
		=dev-elixir/mime-1.3.0
		dev-elixir/bypass
		=dev-elixir/cowboy-1.0.4
		=dev-elixir/cowlib-1.0.2
		=dev-elixir/ranch-1.2.1
	)
"
RDEPEND="${DEPEND}"
