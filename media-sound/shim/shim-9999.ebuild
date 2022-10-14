# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [ "${PV}" = 9999 ]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rabbits/shim"
	SLOT="0"
else
	EGIT_COMMIT="4248690cecc249ab825753bae6ce25c7f4ac4cd1"
	MY_P="${PN}-${EGIT_COMMIT}"
	SRC_URI="https://git.sr.ht/~rabbits/shim/archive/${EGIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	SLOT="0/${PV}"

	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="Pipe 3-bytes packets (channel, note, velocity) to a MIDI device"
HOMEPAGE="https://git.sr.ht/~rabbits/shim/"
LICENSE="MIT"
SLOT="0"

RDEPEND="media-libs/portmidi"
DEPEND="${RDEPEND}"

src_compile() {
	# ./build.sh ignores CC and compiler flags (CFLAGS, LDFLAGS, …) making it unsuitable
	# portmidi lacks a pkg-config file
	"${CC:-cc}" -std=c89 ${CFLAGS} shim.c -o shim -lportmidi || die
}

src_install() {
	einstalldocs
	dobin shim
}
