# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="glob(1) wrapper around glob(3), inspired by https://github.com/isaacs/node-glob"
HOMEPAGE="https://hacktivis.me/git/cmd-glob"
SRC_URI="https://hacktivis.me/releases/${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"

src_install() {
	PREFIX='/usr' default
}
