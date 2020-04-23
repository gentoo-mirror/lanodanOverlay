# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sndio audio sink and source for GStreamer"
HOMEPAGE="https://github.com/Duncaen/alsa-sndio"
SRC_URI="https://github.com/Duncaen/alsa-sndio/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/alsa-lib
	media-sound/sndio:=
"
RDEPEND="${DEPEND}"

src_install() {
	export PREFIX="/usr"

	default
}
