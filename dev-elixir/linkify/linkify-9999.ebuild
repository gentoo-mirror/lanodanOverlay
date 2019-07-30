# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION="basic package for turning website names into links"
HOMEPAGE="https://git.pleroma.social/pleroma/linkify"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pleroma.social/pleroma/linkify"
else
	SRC_URI="https://git.pleroma.social/pleroma/linkify/-/archive/v${PV}/linkify-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
SLOT="$(ver_cut 1-2)"
LICENSE="MIT"
IUSE="test doc"

DEPEND="
	test? ( >=dev-elixir/credo-1.1.0 )
	doc? ( >=dev-elixir/ex_doc-0.20 )
"
RDEPEND="${DEPEND}"
