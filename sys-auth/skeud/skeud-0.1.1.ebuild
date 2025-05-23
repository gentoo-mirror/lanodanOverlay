# Copyright 2021-2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="Simple and portable utilities to deal with user accounts (su, login)"
HOMEPAGE="https://hacktivis.me/git/skeud"
if [[ "${PV}" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.hacktivis.me/git/skeud.git"
else
	VERIFY_SIG_METHOD=signify
	inherit verify-sig

	SRC_URI="
		https://distfiles.hacktivis.me/releases/${PN}/${P}.tar.gz
		verify-sig? ( https://distfiles.hacktivis.me/releases/${PN}/${P}.tar.gz.sign )
	"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi
LICENSE="MPL-2.0"
SLOT="0"
IUSE="static test"

RESTRICT="!test? ( test )"

DEPEND="virtual/libcrypt:="
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

if [[ "${PV}" != 9999* ]]
then
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
fi

src_compile() {
	use static && export LDSTATIC='-static'
	default
}

src_install() {
	emake install DESTDIR="${D}" PREFIX='/opt/lanodan' SYS_BINDIR='/opt/lanodan/bin'

	# before 50baselayout
	newenvd - 40skeud <<-EOF
		PATH="/opt/lanodan/bin"
		MANPATH="/opt/lanodan/share/man"
	EOF
}
