# Copyright 2018-2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="library which provides the <ucontext.h> API from older POSIX revisions"
HOMEPAGE="https://code.foxkit.us/adelie/libucontext"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64  ~x86"
LICENSE="MIT"
SRC_URI="https://distfiles.adelielinux.org/source/${PN}/${P}.tar.xz"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

get_kernel_arch() {
	case "$ABI" in
		amd64) echo "x86_64";;
		*) echo $ABI;;
	esac
}

src_prepare() {
	default

	sed -i \
		-e 's;^LIBUCONTEXT_PATH = ;\0 /usr;' \
		-e 's;^LIBUCONTEXT_STATIC_PATH = ;\0 /usr;' \
		-e 's;ln -sf ${LIBUCONTEXT_SONAME} ${DESTDIR};\0/usr;' \
		"${S}/Makefile" || die "Failed adjusting prefix to /usr"
}

src_compile() {
	emake ARCH="$(get_kernel_arch)"
}

src_test() {
	emake ARCH="$(get_kernel_arch)" check
}

src_install() {
	emake ARCH="$(get_kernel_arch)" DESTDIR="${ED}" install
}
