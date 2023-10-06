# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Helper module for loading your native module's .node file"
HOMEPAGE="https://github.com/TooTallNate/node-bindings"
SRC_URI="https://github.com/TooTallNate/node-bindings/archive/refs/tags/${PV}.tar.gz -> node-${P}.tar.gz"
S="${WORKDIR}/node-${P}/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-nodejs/file-uri-to-path"

RESTRICT="test" # no tests
