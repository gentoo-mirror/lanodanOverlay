# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Sophisticated chroot/build/flash tool to develop and install postmarketOS."
HOMEPAGE="https://postmarketos.org/ https://pypi.org/project/pmbootstrap/"
SRC_URI="https://files.pythonhosted.org/packages/ed/73/32c8d35f551dfb29018ffb9980d7ef08252f343809b6fb810a0febc9bc09/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
