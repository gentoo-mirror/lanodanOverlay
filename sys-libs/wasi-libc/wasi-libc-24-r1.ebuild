# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="wasi-libc-wasi-sdk-${PV}"

DESCRIPTION="WASI libc implementation for WebAssembly"
HOMEPAGE="https://github.com/WebAssembly/wasi-libc"
SRC_URI="https://github.com/WebAssembly/wasi-libc/archive/refs/tags/wasi-sdk-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/"
LICENSE="Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT CC0-1.0 BSD-2 MIT BSD"
SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	llvm-core/clang
	llvm-core/llvm
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/wasi-libc-24-no-double-build.patch"
)

src_prepare() {
	default
	rm libc-bottom-half/sources/wasip2_component_type.o || die
}

src_configure() {
	tc-export CC NM AR

	tc-is-clang || die "Compiler isn't clang"
}

src_compile() {
	# gentoo defines SYSROOT
	emake SYSROOT="${S}/sysroot/"
}

src_install() {
	emake SYSROOT="${S}/sysroot/" INSTALL_DIR="${ED}/usr/share/wasi-sysroot" install
}
