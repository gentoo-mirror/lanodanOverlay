# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Utility for normalizing a numeric range, including a wrapping function"
HOMEPAGE="https://github.com/jamestalmage/normalize-range"
SRC_URI="https://github.com/jamestalmage/normalize-range/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # extra deps
