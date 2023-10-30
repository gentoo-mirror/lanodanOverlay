# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs git-r3

DESCRIPTION="Command to convert Japanese from/to Kana/Kanji/Romaji with furigana option"
HOMEPAGE="https://hacktivis.me/git/kanaconv/"
EGIT_REPO_URI="https://hacktivis.me/git/kanaconv.git"
LICENSE="MIT"
SLOT="0"

RESTRICT="test" # Has no tests

RDEPEND="
	dev-nodejs/kuroshiro
	dev-nodejs/kuroshiro-analyzer-mecab
	dev-nodejs/minimist
"
