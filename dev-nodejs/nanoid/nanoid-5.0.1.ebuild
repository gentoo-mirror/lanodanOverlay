# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="tiny, secure, URL-friendly, unique string ID generator for JavaScript"
HOMEPAGE="https://github.com/ai/nanoid"
SRC_URI="https://github.com/ai/nanoid/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"

RESTRICT="test" # Uses pnpm to run testsuite
