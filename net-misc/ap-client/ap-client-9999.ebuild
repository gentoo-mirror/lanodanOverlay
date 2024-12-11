# Copyright 2021-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="CLI-based client / toolbox for ActivityPub Client-to-Server"
HOMEPAGE="https://hacktivis.me/git/ap-client/"
EGIT_REPO_URI="https://anongit.hacktivis.me/git/ap-client.git"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""

IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
"
DEPEND="
	${RDEPEND}
	test? ( dev-perl/Test-Output )
"
