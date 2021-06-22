# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Large Vocabulary Continuous Speech Recognition Engine"
HOMEPAGE="https://github.com/julius-speech/julius"
SRC_URI="https://github.com/julius-speech/julius/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="julius"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa oss portaudio pulseaudio sndfile"
REQUIRED_USE="^^ ( alsa oss portaudio pulseaudio )"

RDEPEND="
	dev-lang/perl
	dev-perl/Jcode
	sys-libs/readline:0
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	sys-devel/flex"

pkg_postinst() {
	eerror "IMPORTANT NOTICE"
	elog "/usr/bin/jcontrol has been renamed to /usr/bin/jucontrol"
	elog "to avoid file collision with dev-java/java-config."
	elog "If this creates a problem with applications, file a gentoo bug."
}
