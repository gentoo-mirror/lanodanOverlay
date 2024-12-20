# Copyright 2021-2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.hacktivis.me/git/utils-std.git"
else
	VERIFY_SIG_METHOD=signify
	inherit verify-sig

	SRC_URI="
		https://hacktivis.me/releases/utils-std/${P}.tar.gz
		verify-sig? ( https://hacktivis.me/releases/utils-std/${P}.tar.gz.sign )
	"

	KEYWORDS="~amd64 ~arm64 ~riscv"
fi


DESCRIPTION="Collection of commonly available Unix tools"
HOMEPAGE="https://hacktivis.me/git/utils-std"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test static system"

RESTRICT="!test? ( test )"

RDEPEND="
	system? (
		!sys-apps/coreutils[system(+)]
		!sys-apps/diffutils[system(+)]
	)
"
BDEPEND="
	app-alternatives/yacc
	test? ( dev-util/cram )
"

if [[ "${PV}" != 9999* ]]
then
	BDEPEND="${BDEPEND} verify-sig? ( sec-keys/signify-keys-lanodan:2024 )"

	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/signify-keys/signify-keys-lanodan-2024.pub"

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

src_configure() {
	export NO_BWRAP=1

	use static && export LDSTATIC="-static-pie"

	./configure PREFIX=$(usex system '/usr' '/opt/lanodan')
}

src_install() {
	emake install DESTDIR="${D}"

	# before 50baselayout
	use system || newenvd - 40lanodan <<-EOF
		PATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		ROOTPATH="/opt/lanodan/bin:/opt/lanodan/sbin"
		MANPATH="/opt/lanodan/share/man"
	EOF
}
