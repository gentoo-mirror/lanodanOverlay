# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Analyse texts for word probabilities and generate random sentences"
HOMEPAGE="https://www.jwz.org/dadadodo/"
SRC_URI="https://www.jwz.org/dadadodo/dadadodo-1.04.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=( "dodotodo" "README" )

src_install() {
	einstalldocs
	dobin dadadodo
}
