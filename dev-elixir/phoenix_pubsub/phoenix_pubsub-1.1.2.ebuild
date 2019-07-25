# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

MIX_REWRITE="true"

DESCRIPTION="Distributed PubSub and Presence platform for the Phoenix Framework"
HOMEPAGE="https://github.com/phoenixframework/phoenix_pubsub"
LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
SRC_URI="https://github.com/phoenixframework/phoenix_pubsub/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	doc? ( dev-elixir/ex_doc )
"
RDEPEND="${DEPEND}"
