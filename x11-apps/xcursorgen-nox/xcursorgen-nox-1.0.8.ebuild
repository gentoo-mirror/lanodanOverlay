# Copyright 2023-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=signify
inherit verify-sig

DESCRIPTION="create an X cursor file from a collection of PNG images (no libX11)"
HOMEPAGE="https://hacktivis.me/git/xcursorgen-nox/"
SRC_URI="
	https://distfiles.hacktivis.me/releases/${P}.tar.gz
	verify-sig? ( https://distfiles.hacktivis.me/releases/${P}.tar.gz.sign )
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}"

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
