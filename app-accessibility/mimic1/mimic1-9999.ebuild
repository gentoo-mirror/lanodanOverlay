# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Mycroft's TTS engine, based on CMU's Flite (Festival Lite)"
HOMEPAGE="https://mimic.mycroft.ai/"
EGIT_REPO_URI="https://github.com/MycroftAI/mimic1.git"

LICENSE="BSD MIT public-domain freetts BSD-2 Apache-2.0"
SLOT="0"
IUSE="alsa portaudio pulseaudio oss"

DEPEND="
	dev-libs/libpcre2
	dev-libs/hts_engine
	alsa? ( media-libs/alsa-lib )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i 's/-Werror//' Makefile.am

	eautoreconf
}
