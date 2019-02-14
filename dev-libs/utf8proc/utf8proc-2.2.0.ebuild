# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="library for processing UTF-8 encoded Unicode strings"
HOMEPAGE="https://juliastrings.github.io/utf8proc/"
SRC_URI="https://github.com/JuliaStrings/utf8proc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" prefix="/usr"
}
