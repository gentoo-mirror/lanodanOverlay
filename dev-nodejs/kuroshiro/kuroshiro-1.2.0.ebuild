# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Convert Japanese to Hiragana, Katakana or Romaji with furigana and okurigana modes"
HOMEPAGE="https://kuroshiro.org/"
SRC_URI="https://github.com/hexenq/kuroshiro/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/esbuild"

RESTRICT="test" # Uses jest

src_compile() {
	# Uses babel by default, let's use esbuild for now instead to create a similar result
	esbuild --bundle src/index.js --outdir=lib --minify --sourcemap || die
}
