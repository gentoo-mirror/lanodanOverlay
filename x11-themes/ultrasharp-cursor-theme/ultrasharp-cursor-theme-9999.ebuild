# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 ninja-utils

DESCRIPTION="Precision and speed oriented cursor theme"
HOMEPAGE="https://hacktivis.me/projects/ultrasharp-cursor-theme"
EGIT_REPO_URI="https://hacktivis.me/git/ultrasharp-cursor-theme.git"
LICENSE="CC-BY-SA-4.0"
SLOT="0"

BDEPEND="
	|| (
		x11-apps/xcursorgen
		x11-apps/xcursorgen-nox
	)
"

src_configure() {
	./configure PREFIX=/usr || die
}

src_compile() {
	eninja
}

src_install() {
	DESTDIR="${ED}" eninja install
}
