# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Mecab morphological analyzer for kuroshiro"
HOMEPAGE="https://github.com/hexenq/kuroshiro-analyzer-mecab"
SRC_URI="https://github.com/hexenq/kuroshiro-analyzer-mecab/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/esbuild"
RDEPEND="dev-nodejs/mecab-async"

RESTRICT="test" # Uses jest

src_prepare() {
	default
	#sed -i '/"module":/a"type": "module",' package.json || die

	# Can't import node:child_process, only require()
	sed -i \
		-e 's;^import Mecab from "mecab-async";const Mecab = require("mecab-async");' \
		-e 's;export default ;module.exports = ;' \
		src/index.js || die
}


src_compile() {
	# Uses babel by default, let's use esbuild for now instead to create a similar result
	esbuild --bundle src/index.js --outdir=lib --minify --sourcemap --platform=node || die
}
