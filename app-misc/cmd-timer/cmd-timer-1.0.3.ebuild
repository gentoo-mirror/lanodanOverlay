# Copyright 2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=signify
inherit verify-sig

DESCRIPTION="run command at a specific interval"
HOMEPAGE="https://hacktivis.me/git/cmd-timer/"
SRC_URI="
	https://distfiles.hacktivis.me/releases/cmd-timer/${P}.tar.gz
	verify-sig? ( https://distfiles.hacktivis.me/releases/cmd-timer/${P}.tar.gz.sign )
"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static"

BDEPEND="${BDEPEND} verify-sig? ( sec-keys/signify-keys-lanodan:2025 )"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/signify-keys/signify-keys-lanodan-2025.pub"

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links
		cd "${DISTDIR}" || die
		cp ${A} "${WORKDIR}" || die
		cd "${WORKDIR}" || die
		verify-sig_verify_detached "${P}.tar.gz" "${P}.tar.gz.sign"
		unpack "${P}.tar.gz"
		rm "${P}.tar.gz"
	else
		default
	fi
}

src_configure() {
	use static && export LDSTATIC=-static
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
}
