# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION="JSON Object Signing and Encryption (JOSE) for Erlang and Elixir"
HOMEPAGE="https://github.com/potatosalad/erlang-jose"
LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
SRC_URI="https://github.com/potatosalad/erlang-jose/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test doc"
RESTRICT="!test? ( test )"

DEPEND="
	dev-elixir/hex
	>=dev-erlang/base64url-0.0.1
	test? (
		dev-elixir/cutkey
		>=dev-elixir/jsone-1.4
		>=dev-elixir/jsx-2.8
		>=dev-elixir/libdecaf-0.0.4
		>=dev-elixir/libsodium-0.0.10
		>=dev-elixir/ojson-1.0
		>=dev-elixir/poison-3.1
	)
	doc? (
		>=dev-elixir/ex_doc-0.15
		>=dev-elixir/earkmark-1.2
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/erlang-${P}"
