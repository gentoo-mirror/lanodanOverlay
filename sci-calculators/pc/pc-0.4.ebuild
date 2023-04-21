# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="9front's pc(1) (Programmer's Calculator) for Unix"
HOMEPAGE="https://sr.ht/~ft/pc/"
SRC_URI="https://git.sr.ht/~ft/pc/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	PREFIX=/usr default
}
