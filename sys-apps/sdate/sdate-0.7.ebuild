# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="never ending September date"
HOMEPAGE="https://www.df7cb.de/projects/sdate/"
SRC_URI="https://github.com/df7cb/sdate/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	default
	eautoreconf
}
