# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="CLI-based client / toolbox for ActivityPub Client-to-Server"
HOMEPAGE="https://hacktivis.me/git/ap-client/"
EGIT_REPO_URI="https://hacktivis.me/git/ap-client.git"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-perl/JSON-MaybeXS
	dev-perl/LWP-Protocol-https
"
RDEPEND="${DEPEND}"
