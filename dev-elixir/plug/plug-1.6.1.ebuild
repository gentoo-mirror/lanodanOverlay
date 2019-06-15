# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

MIX_REWRITE=true

DESCRIPTION="specification and conveniences for composable modules between web applications"
HOMEPAGE="https://github.com/elixir-plug/plug"
LICENSE="Apache-2.0"
SLOT="0"
SRC_URI="https://github.com/elixir-plug/plug/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="telemetry doc"

DEPEND="
	>=dev-elixir/mime-1.0
	>=dev-elixir/plug_crypto-1.0
	telemetry? ( >=dev-elixir/telemetry-0.4 )
	doc? ( >=dev-elixir/ex_doc-0.19.1 )
"
RDEPEND="${DEPEND}"
