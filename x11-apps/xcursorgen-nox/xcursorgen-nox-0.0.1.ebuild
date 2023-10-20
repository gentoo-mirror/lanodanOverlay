# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="create an X cursor file from a collection of PNG images (no libX11)"
HOMEPAGE="https://hacktivis.me/git/xcursorgen-nox/"
SRC_URI="https://hacktivis.me/releases/xcursorgen-nox-0.0.1.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}"
