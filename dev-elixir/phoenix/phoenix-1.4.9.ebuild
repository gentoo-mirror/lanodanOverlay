# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

MIX_REWRITE="true"

DESCRIPTION="productive web framework that does not compromise speed or maintainability"
HOMEPAGE="https://github.com/phoenixframework/phoenix"
LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
SRC_URI="https://github.com/phoenixframework/phoenix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE="doc json"

DEPEND="
	|| (
		dev-elixir/plug:1.8
		dev-elixir/plug:1.9
	)
	dev-elixir/telemetry:0.4
	dev-elixir/phoenix_pubsub:1.1
	json? ( dev-elixir/jason:1.0 )
	doc? (
		dev-elixir/ex_doc:0.20
		dev-elixir/inch_ex:0.2
	)
	test? (
		dev-elixir/gettext:0.15
		dev-elixir/phoenix_html:2.11
		dev-elixir/websocket_client
	)
"
RDEPEND="${DEPEND}"
