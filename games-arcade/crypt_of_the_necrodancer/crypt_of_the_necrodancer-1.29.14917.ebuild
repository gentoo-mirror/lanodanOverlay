# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="Crypt of the Necrodancer (GOG)"
HOMEPAGE="https://www.gog.com/game/crypt_of_the_necrodancer"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

SRC_URI="${PN}_en_${MY_PV}.sh"
S="${WORKDIR}"

dir="/opt/${PN}"

RESTRICT="bindist fetch strip"
QA_PREBUILT="${dir#/}/*"

BDEPEND="app-arch/unzip"

DEPEND="
	media-libs/openal[abi_x86_32]
	media-libs/glfw:2[abi_x86_32]
	media-libs/libogg[abi_x86_32]
	media-libs/libvorbis[abi_x86_32]
"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	elog "Please buy and download ${A} from:"
	elog "  https://www.gog.com/game/crypt_of_the_necrodancer"
	elog "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}


src_install() {
	exeinto "${dir}"
	doexe data/noarch/game/NecroDancer
	dosym "${dir}/NecroDancer" "/usr/bin/${PN}"

	insinto "${dir}"
	doins -r data/noarch/game/data/
	doins -r data/noarch/game/fmod/
}
