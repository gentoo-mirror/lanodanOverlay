# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Libraries and tools implementing the tcb password shadowing scheme"
HOMEPAGE="http://www.openwall.com/tcb/"
SRC_URI="https://www.openwall.com/tcb/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pam static-libs"

DEPEND="
	acct-group/chkpwd
	acct-group/shadow
	sys-libs/libxcrypt:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's;CC =;#&;' "${S}/Make.defs" || die "Failed un-forcing CC"

	if use !pam; then
		sed -i '/pam_tcb/d' Makefile \
			|| die "Failed disabling pam_tcb"
	fi

	default
}

src_install() {
	einstalldocs
	emake install DESTDIR="${D}" \
		SLIBDIR=/$(get_libdir) LIBDIR=/usr/$(get_libdir) MANDIR=/usr/share/man

	use static-libs || find "${D}" -name '*.a' -delete
}
