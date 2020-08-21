# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial meson

DESCRIPTION="Wayland (wlroots-based) screen capture plugin for obs-studio"
HOMEPAGE="https://hg.sr.ht/~scoopta/wlrobs"
EHG_REPO_URI="${HOMEPAGE}"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-libs/wayland
	media-video/obs-studio[wayland]
"
RDEPEND="${DEPEND}"
