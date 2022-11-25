# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Hare programming language specification"
HOMEPAGE="https://git.sr.ht/~sircmpwn/hare-specification"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/hare-specification"
LICENSE="CC-BY-ND-4.0"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND="
	app-text/texlive[xetex]
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-latexextra
"

DOCS=( specification.pdf )

src_compile() {
	emake
	emake # for the ToC
}

src_install() {
	einstalldocs
}
