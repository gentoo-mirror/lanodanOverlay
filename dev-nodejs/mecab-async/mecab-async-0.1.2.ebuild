# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Asynchronous japanese morphological analyser using MeCab"
HOMEPAGE="https://github.com/hecomi/node-mecab-async"

# No tags in the git repo, use version-change commit
EGIT_COMMIT="f3b2b9ce10914c7b3ff3b69cc09991d8df2e4aee"
SRC_URI="https://github.com/hecomi/node-mecab-async/archive/${EGIT_COMMIT}.tar.gz -> node-${PN}-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/node-${PN}-${EGIT_COMMIT}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-nodejs/shell-quote
	app-text/mecab
"
DEPEND="test? ( ${RDEPEND} )"

src_test() {
	node test.js || die
}
