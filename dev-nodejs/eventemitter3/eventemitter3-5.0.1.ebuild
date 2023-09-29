# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="EventEmitter3 focuses on performance while maintaining a Node.js AND browser compatible interface"
HOMEPAGE="https://github.com/primus/eventemitter3"
SRC_URI="https://github.com/primus/eventemitter3/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"
