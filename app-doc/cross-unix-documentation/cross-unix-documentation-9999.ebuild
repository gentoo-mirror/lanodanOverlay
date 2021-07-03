# Copyright 2019-2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="documentation of similarities and (noteworthy) differencies between Unix systems"
HOMEPAGE="https://hacktivis.me/git/cross-unix-documentation/"
EGIT_REPO_URI="https://hacktivis.me/git/cross-unix-documentation.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="CC-BY-4.0"
SLOT="0"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
