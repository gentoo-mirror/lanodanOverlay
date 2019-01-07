# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Minimalist and privacy-oriented WebKitGTK+ browser"
HOMEPAGE="https://hacktivis.me/git/badwolf"
EGIT_REPO_URI="https://hacktivis.me/git/badwolf.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DOCS=("README.md" "KnowledgeBase.md")

DEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk
"
