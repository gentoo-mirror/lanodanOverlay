# Copyright 2023-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=signify
inherit nodejs verify-sig

DESCRIPTION="Command to convert Japanese from/to Kana/Kanji/Romaji with furigana option"
HOMEPAGE="https://hacktivis.me/git/kanaconv/"
SRC_URI="
	https://distfiles.hacktivis.me/releases/${P}.tar.gz
	verify-sig? ( https://distfiles.hacktivis.me/releases/${P}.tar.gz.sign )
"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"

RESTRICT="test" # Has no tests

RDEPEND="
	dev-nodejs/kuroshiro:0
	dev-nodejs/kuroshiro-analyzer-mecab
	dev-nodejs/minimist
"

BDEPEND="verify-sig? ( sec-keys/signify-keys-lanodan:2024 )"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/signify-keys/signify-keys-lanodan-2024.pub"

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links
		cd "${DISTDIR}" || die
		cp ${A} "${WORKDIR}" || die
		cd "${WORKDIR}" || die
		verify-sig_verify_detached "${P}.tar.gz" "${P}.tar.gz.sign"
	fi

	default
}
