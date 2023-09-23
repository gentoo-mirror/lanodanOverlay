# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="mdoc(7) versions of the documentation for the execline suite"
HOMEPAGE="https://git.sr.ht/~flexibeast/execline-man-pages"
SRC_URI="https://git.sr.ht/~flexibeast/execline-man-pages/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}/"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
