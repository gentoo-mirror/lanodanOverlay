# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="SDL2 bindings for Hare"
HOMEPAGE="https://sr.ht/~sircmpwn/hare-sdl2"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/hare-sdl2"
LICENSE="MPL-2.0"
SLOT="0"

DEPEND="
	dev-lang/hare
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/sdl2-mixer
"
RDEPEND="${DEPEND}"

src_install() {
	# No install target in Makefile
	insinto "${EROOT}/usr/src/hare/third-party/"
	doins -r sdl2
}
