# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Web client for Pleroma and Mastodon"
HOMEPAGE="https://git.freesoftwareextremist.com/bloat/"
EGIT_REPO_URI="https://git.freesoftwareextremist.com/bloat"
EGIT_MIN_CLONE_TYPE="single+tags"
# /: CC0-1.0
# /vendor/…/gorilla/mux: BSD
# /vendor/…/linkheader: MIT
# /mastodon (go-mastodon): MIT
LICENSE="CC0-1.0 BSD MIT"
SLOT="0"
KEYWORDS=""

# TODO: de-vendor modules by making them proper dev-go/ dependencies
BDEPEND=">=dev-lang/go-1.11"

DOCS=( README bloat.conf )

src_configure() {
	sed -i 's;^PREFIX=.*;PREFIX=/usr;' Makefile || die
}
