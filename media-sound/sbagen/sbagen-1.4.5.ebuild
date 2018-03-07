# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Command line sequenced binaural beat generator"
HOMEPAGE="http://sbagen.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"

IUSE="mp3 vorbis"

DEPEND="mp3? ( media-libs/libmad )
	vorbis? ( media-libs/tremor )"

DOCS="README.md SBAGEN.txt"

src_prepare() {
	default
	rm -r libs || die "Removing third-party libs failed"
	rm sbagen || die "Removing sbagen binary failed"
	sed -i 's;"libs/mad.h";<mad.h>;' mp3dec.c || die "Fixing mp3dec.c include failed"
	sed -i -r 's;include "libs/(.*.h)";include <tremor/\1>;' oggdec.c || die "Fixing oggdec.c include failed"
}

src_compile() {
	if use vorbis; then
		append-flags -DOGG_DECODE -ltremor
	fi
	if use mp3; then
		append-flags -DMP3_DECODE -lmad
	fi

	$(tc-getCC) ${CFLAGS} -DT_LINUX -Wall -lm -lpthread ${LDFLAGS} sbagen.c -o sbagen || die "Sbagen: compilation failed"
}

src_install() {
	dobin sbagen
	if use vorbis; then
		insinto
		doins *.ogg
	fi
	einstalldocs
}
