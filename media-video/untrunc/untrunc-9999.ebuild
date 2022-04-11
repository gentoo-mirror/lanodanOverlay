# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Restore a truncated mp4/mov"
HOMEPAGE="https://github.com/anthwlock/untrunc"
EGIT_REPO_URI="https://github.com/anthwlock/untrunc"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-video/ffmpeg:=
"
RDEPEND="${DEPEND}"

src_install() {
	einstalldocs
	dobin untrunc
}
