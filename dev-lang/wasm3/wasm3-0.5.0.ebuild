# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast WebAssembly interpreter and the most universal WASM runtime"
HOMEPAGE="https://github.com/wasm3/wasm3"
SRC_URI="https://github.com/wasm3/wasm3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	# WASM blobs formatted as C headers
	rm source/extra/*.wasm.h || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_WASI=simple
	)

	cmake_src_configure
}

src_install() {
	einstalldocs

	dobin "${BUILD_DIR}/wasm3"
	dolib.a "${BUILD_DIR}source/libm3.a"
}
