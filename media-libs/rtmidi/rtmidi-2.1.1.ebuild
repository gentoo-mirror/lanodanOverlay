# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="common C++ API for realtime MIDI input/output"
HOMEPAGE="http://www.music.mcgill.ca/~gary/rtmidi/"
SRC_URI="http://www.music.mcgill.ca/~gary/rtmidi/release/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa doc +jack"
RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}_buildsystem.patch"
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_with alsa) \
	$(use_with jack) || die "./configure failed"
}

#src_compile() {
#	emake -j1 || die "make failed"
#}

#src_install() {
#	dodoc readme
#	if use doc; then
#		dodoc doc/release.txt
#		dohtml doc/html/*
#	fi
#	dolib.so librtmidi.so.1.2.0.1
#	dosym "librtmidi.so.1.2.0.1" "/usr/$(get_libdir)/librtmidi.so"
#	dosym "librtmidi.so.1.2.0.1" "/usr/$(get_libdir)/librtmidi.so.1"
#	insinto /usr/$(get_libdir)/pkgconfig
#	doins rtmidi.pc
#	insinto /usr/include
#	doins RtMidi.h RtError.h
#}
