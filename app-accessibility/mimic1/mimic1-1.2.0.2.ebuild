# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Mycroft's TTS engine, based on CMU's Flite (Festival Lite)"
HOMEPAGE="https://mimic.mycroft.ai/"
SRC_URI="https://github.com/MycroftAI/mimic1/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT public-domain freetts BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
# Note: supports Sun audioio
IUSE="alsa portaudio pulseaudio oss"

DEPEND="
	dev-libs/icu:=
	alsa? ( media-libs/alsa-lib )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i 's/-Werror//' Makefile.am || die "Failed removing -Werror"

	eautoreconf
}
