# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Slack module for libpurple"
HOMEPAGE="https://github.com/dylex/slack-libpurple"
EGIT_REPO_URI="https://github.com/dylex/slack-libpurple.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="net-im/pidgin"
RDEPEND="${DEPEND}"
