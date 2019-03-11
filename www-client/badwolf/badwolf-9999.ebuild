# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 savedconfig

DESCRIPTION="Minimalist and privacy-oriented WebKitGTK+ browser"
HOMEPAGE="https://hacktivis.me/git/badwolf"
EGIT_REPO_URI="https://hacktivis.me/git/badwolf.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DOCS=("README.md" "KnowledgeBase.md")

DEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk
"

src_configure() {
	restore_config config.h
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	save_config config.h
	einstalldocs
}
