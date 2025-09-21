# Copyright 2021-2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=signify
inherit verify-sig

DESCRIPTION="Simple and portable utilities to deal with user accounts (su, login)"
HOMEPAGE="https://hacktivis.me/git/skeud"
SRC_URI="
	https://distfiles.hacktivis.me/releases/${PN}/${P}.tar.gz
	verify-sig? ( https://distfiles.hacktivis.me/releases/${PN}/${P}.tar.gz.sign )
"
KEYWORDS="~amd64 ~arm64 ~riscv"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="system test"

RESTRICT="!test? ( test )"

DEPEND="virtual/libcrypt:="
RDEPEND="
	${DEPEND}
	system? (
		!sys-apps/shadow[su]
		!sys-apps/util-linux[su]
	)
"
BDEPEND="
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"

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
	if use system; then
		into /
		dosbin su
		fperms 4755 sbin/su
		newsbin login skeud-login
		fperms 0755 sbin/skeud-login

		newman login.1 skeud-login.1
	else
		emake install DESTDIR="${D}" PREFIX='/opt/lanodan' SYS_BINDIR='/opt/lanodan/bin'

		# before 50baselayout
		newenvd - 40skeud <<-EOF
			PATH="/opt/lanodan/bin"
			MANPATH="/opt/lanodan/share/man"
		EOF
	fi
}
