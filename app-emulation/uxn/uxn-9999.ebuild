# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rabbits/uxn"
else
	KEYWORDS=""
fi

DESCRIPTION="Assembler and emulator for the Uxn stack-machine, written in ANSI C"
HOMEPAGE="https://sr.ht/~rabbits/uxn/"
LICENSE="MIT"
SLOT="0"

DEPEND="
	media-libs/libsdl2
"
RDEPEND="${DEPEND}"

src_compile() {
	./build.sh --no-run || die
}

src_install() {
	einstalldocs
	dobin bin/*
}
