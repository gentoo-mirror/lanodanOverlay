# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 1- '')

DESCRIPTION="Libraries of the fmodex audio engine"
HOMEPAGE="https://zdoom.org/files/fmod/ https://www.fmod.com/"
SRC_URI="https://zdoom.org/files/fmod/fmodapi${MY_PV}linux.tar.gz"
S="${WORKDIR}/fmodapi${MY_PV}linux"

# Ogg Vorbis: BSD
# Android: BSD-2
LICENSE="BSD BSD-2 fmod"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="strip test"

QA_PREBUILT="*"

src_compile() { :; }

src_install() {
	cd "${S}/api/lib/" || die
	for lib in libfmodex libfmodexL
	do
		dolib.so ${lib}64-${PV}.so
		dolib.so ${lib}64.so
		dolib.so ${lib}-${PV}.so
		dolib.so ${lib}.so
	done

	cd "${S}/fmoddesignerapi/api/lib/" || die
	for lib in libfmodevent libfmodeventL libfmodeventnet libfmodeventnetL
	do
		dolib.so ${lib}64-${PV}.so
		dolib.so ${lib}64.so
		dolib.so ${lib}-${PV}.so
		dolib.so ${lib}.so
	done
}
