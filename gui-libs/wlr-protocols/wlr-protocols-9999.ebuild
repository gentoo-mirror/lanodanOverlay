# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [ "${PV}" = 9999 ]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wlroots/wlr-protocols.git"
else
	EGIT_COMMIT="4264185db3b7e961e7f157e1cc4fd0ab75137568"
	SRC_URI="https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/archive/${EGIT_COMMIT}/${PN}-${EGIT_COMMIT}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Wayland protocols designed for use in wlroots (and other compositors)"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlr-protocols"
LICENSE="MIT"
SLOT="0"

src_compile() { :; }
