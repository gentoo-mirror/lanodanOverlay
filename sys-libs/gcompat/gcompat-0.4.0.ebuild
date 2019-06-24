# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="The GNU C Library compatibility layer for musl"
HOMEPAGE="https://code.foxkit.us/adelie/gcompat"
KEYWORDS="~amd64 ~x86"
LICENSE="UoI-NCSA"
IUSE="obstack"
SRC_URI="https://distfiles.adelielinux.org/source/gcompat/${P}.tar.xz"
SLOT="0"

DEPEND="obstack? ( sys-libs/obstack-standalone )"
RDEPEND="${DEPEND}"

get_loader_name() {
	# Loosely based on Adélie APKBUILD
	# TODO: Check against glibc’s logic

	case "$ABI" in
		x86) echo "ld-linux.so.2" ;;
		amd64) echo "ld-linux-x86-64.so.2" ;;
		arm*) echo "ld-linux-armhf.so.3" ;;
		arm64) echo "ld-linux-aarch64.so.1" ;;
		mips | powerpc | s390) echo "ld.so.1" ;;
	esac
}

get_linker_path() {
	local arch=$(ldd 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')
	echo "/lib/ld-musl-${arch}.so.1"
}

src_compile() {
	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')"
}

src_install() {
	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')" \
		DESTDIR="${D}" \
		install
}
