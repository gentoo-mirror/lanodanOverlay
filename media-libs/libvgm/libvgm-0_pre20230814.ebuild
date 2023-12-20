# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="more modular rewrite of most components from VGMPlay"
HOMEPAGE="https://github.com/ValleyBell/libvgm"
EGIT_COMMIT="91b6542a25a754f985181921331bdcbb2699c03c"
SRC_URI="https://github.com/ValleyBell/libvgm/archive/${EGIT_COMMIT}.tar.gz -> libvgm-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/libvgm-${EGIT_COMMIT}"
# Maybe a bit more complex than that given GPL-2 code so bindist https://github.com/ValleyBell/libvgm/issues/43
LICENSE="all-rights-reserved GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist"

# FIXME: Configure cmake enough to avoid automagic
DEPEND="
	media-libs/alsa-lib
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
