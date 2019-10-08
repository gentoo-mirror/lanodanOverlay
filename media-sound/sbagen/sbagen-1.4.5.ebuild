# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Command line sequenced binaural beat generator"
HOMEPAGE="https://sbagen.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz
	vorbis? ( sounds? ( https://uazu.net/sbagen/sbagen-river-1.4.1.tgz ) )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

IUSE="mp3 vorbis sounds"

DEPEND="mp3? ( media-libs/libmad )
	vorbis? ( media-libs/tremor )"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS="README.txt SBAGEN.txt"

src_prepare() {
	default
	rm -r libs || die "Removing third-party libs failed"
	rm sbagen || die "Removing sbagen binary failed"
	sed -i 's;"libs/mad.h";<mad.h>;' mp3dec.c || die "Fixing mp3dec.c include failed"
	sed -i -r 's;include "libs/(.*.h)";include <tremor/\1>;' oggdec.c || die "Fixing oggdec.c include failed"
}

src_compile() {
	if use vorbis; then
		append-flags -DOGG_DECODE $(pkg-config --libs vorbisidec)
	fi
	if use mp3; then
		append-flags -DMP3_DECODE $(pkg-config --libs mad)
	fi

	$(tc-getCC) ${CFLAGS} -DT_LINUX -Wall -lpthread ${LDFLAGS} sbagen.c -o sbagen || die "Sbagen: compilation failed"
}

src_install() {
	dobin sbagen
	if use sounds; then
		cd ../sbagen-1.4.1
		insinto "/usr/share/${PN}"
		doins *.ogg
	fi
	einstalldocs
}
