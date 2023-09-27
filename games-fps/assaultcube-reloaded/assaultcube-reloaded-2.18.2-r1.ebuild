# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="AssaultCube Reloaded"
HOMEPAGE="https://acr.victorz.ca/"
SRC_URI="
	https://github.com/acreloaded/acr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/acreloaded/acr/pull/201/commits/7dad5c8a1a66ade36ca9d8612b3f0b93f6c990a4.patch -> ${PN}-PR201-system-enet.patch
"
S="${WORKDIR}/acr-${PV}/source/src"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="system-enet +X"

DEPEND="
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/openal
	media-libs/libvorbis
	net-misc/curl
	virtual/opengl
	X? ( x11-libs/libX11 )
	system-enet? ( net-libs/enet )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Remove windows and MacOS blobs
	rm -r "${WORKDIR}/acr-${PV}/source/lib" "${WORKDIR}/acr-${PV}/bin_win32" "${WORKDIR}/acr-${PV}/source/xcode/Frameworks" || die

	if use system-enet; then
		rm -r ../enet || die
		eapply -p3 "${DISTDIR}/${PN}-PR201-system-enet.patch"
		#sed -i \
		#	-e 's;-L../enet/.libs ;;' \
		#	-e 's;-I../enet/include;;' \
		#	-e 's;client: libenet;client: ;' \
		#	-e 's;server: libenet;server: ;' \
		#	-e 's;master: libenet;master: ;' \
		#	Makefile || die
	fi

	sed -i 's;-lGL;-lOpenGL;' Makefile || die

	# Pulls <execinfo.h> which is glibc-specific
	sed -i 's;#elif defined(linux) .*;#elif defined(__GLIBC__);' tools.cpp || die

	# Uses std::basic_string with no CPP includes
	sed -i '1a#include <string>' console.h || die

	# Breaks due to features like std::clamp added in C++17
	append-cxxflags -std=c++14

	# clipboard
	if use !X; then
		sed -i 's;-lX11;;' Makefile || die
		sed -i \
			-e '/^#if !defined(WIN32) && !defined(__APPLE__)$/,/#endif/d' \
			-e '/^void pasteconsole/,/^}$/d' \
			-e '/struct hline/ivoid pasteconsole(char *) { }\n' \
			console.cpp || die
	fi
}

src_install() {
	default

	newbin - ${PN}_client <<EOF
#!/bin/sh
cd "/usr/share/${PN}" || exit 1

"/usr/libexec/${PN}/ac_client" "\$@"
EOF

	newbin - ${PN}_server <<EOF
#!/bin/sh
cd "/usr/share/${PN}" || exit 1

"/usr/libexec/${PN}/ac_server" "\$@"
EOF

	exeinto "/usr/libexec/${PN}"
	doexe ac_server ac_client

	cd "${WORKDIR}/acr-${PV}" || die
	insinto "/usr/share/${PN}"
	doins -r bot config packages acr/packages
}
