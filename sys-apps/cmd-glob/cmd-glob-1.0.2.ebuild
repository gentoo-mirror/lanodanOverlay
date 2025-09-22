# Copyright 2023-2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=signify
inherit verify-sig

DESCRIPTION="glob(1) wrapper around glob(3), inspired by https://github.com/isaacs/node-glob"
HOMEPAGE="https://hacktivis.me/git/cmd-glob"
SRC_URI="
	https://distfiles.hacktivis.me/releases/cmd-glob/${P}.tar.gz
	verify-sig? ( https://distfiles.hacktivis.me/releases/cmd-glob/${P}.tar.gz.sign )
"
KEYWORDS="~amd64 ~arm64 ~riscv"
LICENSE="MPL-2.0"
SLOT="0"

BDEPEND="${BDEPEND} verify-sig? ( sec-keys/signify-keys-lanodan:2025 )"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/signify-keys/signify-keys-lanodan-2025.pub"

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links workaround
		cd "${WORKDIR}" || die
		cp "${DISTDIR}/${P}.tar.gz" "${DISTDIR}/${P}.tar.gz.sign" "${WORKDIR}/" || die
		verify-sig_verify_detached "${P}.tar.gz" "${P}.tar.gz.sign"
		unpack "${WORKDIR}/${P}.tar.gz"
		rm "${WORKDIR}/${P}.tar.gz"
	else
		default
	fi
}

src_install() {
	PREFIX='/usr' default
}
