# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

MIX_REWRITE="true"

DESCRIPTION="Crypto-related functionality for the web"
HOMEPAGE="https://github.com/elixir-plug/plug_crypto"
LICENSE="Apache-2.0"
SLOT="0"
SRC_URI="https://github.com/elixir-plug/plug_crypto/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc"

DEPEND="
	doc? ( >=dev-elixir/ex_doc-0.19.1 )
"
RDEPEND="${DEPEND}"
