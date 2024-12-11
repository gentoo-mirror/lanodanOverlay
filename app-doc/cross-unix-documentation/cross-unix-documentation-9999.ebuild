# Copyright 2019-2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="documentation of similarities and (noteworthy) differencies between Unix systems"
HOMEPAGE="https://hacktivis.me/git/cross-unix-documentation/"
EGIT_REPO_URI="https://anongit.hacktivis.me/git/cross-unix-documentation.git"
LICENSE="CC-BY-4.0"
SLOT="0"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
