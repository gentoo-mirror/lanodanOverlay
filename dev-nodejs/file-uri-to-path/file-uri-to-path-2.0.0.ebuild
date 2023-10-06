# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Convert a file: URI to a file path"
HOMEPAGE="https://github.com/TooTallNate/file-uri-to-path"
SRC_URI="https://github.com/TooTallNate/file-uri-to-path/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/esbuild"

# heavy test deps like mocha
RESTRICT="test"

src_compile() {
	# Default is tsc (TypeScript compiler) which doesn't bootstraps from source
	esbuild src/index.ts --outdir=dist/src
}
