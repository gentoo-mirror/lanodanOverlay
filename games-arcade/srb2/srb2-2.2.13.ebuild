# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="3D Sonic fan game based off of Doom Legacy"
HOMEPAGE="https://srb2.org"
SRC_URI="
	https://github.com/STJr/SRB2/archive/refs/tags/SRB2_release_${PV}.tar.gz
	https://github.com/STJr/SRB2/releases/download/SRB2_release_${PV}/SRB2-v${PV//.}-Full.zip
"
S="${WORKDIR}/SRB2-SRB2_release_${PV}/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/game-music-emu
	media-libs/libopenmpt
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/sdl2-mixer
	net-misc/curl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/srb2-2.2.13-execinfo_guard.patch"
)

src_prepare() {
	default

	rm -r libs || die
	rm "${WORKDIR}"/*.dll "${WORKDIR}"/srb2win.exe || die

	# Don't strip executable
	sed -i 's;all : $(exe);all : $(dbg);' src/Makefile || die
}

src_compile() {
	emake -C src/ USE_OPENMP=1 DBGNAME=srb2
}

src_install() {
	dobin bin/srb2

	cd "${WORKDIR}" || die
	insinto /usr/share/games/SRB2
	doins models.dat *.dta *.pk3
}
