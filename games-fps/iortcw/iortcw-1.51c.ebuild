# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Return to Castle Wolfenstein with ioquake3 improvements"
HOMEPAGE="https://github.com/iortcw/iortcw/"
SRC_URI="
	https://github.com/iortcw/iortcw/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/iortcw/iortcw/releases/download/${PV}/patch-data-141.zip
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	virtual/opengl
	media-libs/libsdl2
	games-fps/rtcw-data-gog
"
RDEPEND="${DEPEND}"

my_make() {
	emake \
		ARCH="$(uname -m)" \
		USE_INTERNAL_LIBS=0 \
		USE_OPENAL_DLOPEN=0 \
		USE_CURL_DLOPEN=0 \
		FULLBINEXT='' \
		SHLIBNAME='.so' \
		CLIENTBIN="${PN}-sp" \
		SERVERBIN="${PN}-mp" \
		TOOLS_CC="${CC}" \
		"$@"
}

src_prepare() {
	default

	# remove blobs
	rm -r SP/code/libs MP/code/libs || die

	sed -i \
		-e 's;BR=.*;BR=$(BUILD_DIR)/release;' \
		-e 's;COPYDIR=.*;COPYDIR="/usr/share/wolf";' \
		MP/Makefile SP/Makefile || die
}

src_compile() {
	# singleplayer client
	my_make -C SP
	# multiplayer client + dedicated server
	my_make -C MP
}

src_install() {
	pushd SP/build/release || die
	dobin ${PN}-sp
	dolib \
		renderer_sp_opengl1.so renderer_sp_rend2.so \
		main/cgame.mp.so main/qagame.sp.so main/ui.sp.so
	popd || die

	dobin MP/build/release/${PN}-mp
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
