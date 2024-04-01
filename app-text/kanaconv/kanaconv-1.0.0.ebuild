# Copyright 2023-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Command to convert Japanese from/to Kana/Kanji/Romaji with furigana option"
HOMEPAGE="https://hacktivis.me/git/kanaconv/"
SRC_URI="https://hacktivis.me/releases/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"

RESTRICT="test" # Has no tests

RDEPEND="
	dev-nodejs/kuroshiro:0
	dev-nodejs/kuroshiro-analyzer-mecab
	dev-nodejs/minimist
"
