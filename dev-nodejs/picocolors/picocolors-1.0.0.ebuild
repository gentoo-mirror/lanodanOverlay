# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="tiniest and the fastest library for terminal output formatting with ANSI colors"
HOMEPAGE="https://github.com/alexeyraspopov/picocolors"
SRC_URI="https://github.com/alexeyraspopov/picocolors/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
