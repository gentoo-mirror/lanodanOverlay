# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="https://www.mg0.fr/oshu/samples-v1.tar.bz2 -> oshu-samples-v1.tar.bz2"
KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"

EGIT_REPO_URI="https://github.com/fmang/oshu.git"
#EGIT_COMMIT="1.3.0"

RDEPENDS="
	media-libs/libsdl2:=
	media-libs/sdl2-image:=
	|| (
		media-video/ffmpeg:=
		media-video/libav:=
	)"

DEPENDS="
	${RDEPENDS}
	virtual/pkgconfig
	"

src_prepare() {
	default
	eautoreconf
	(
		cd "${S}/share"
		cp "${DISTDIR}/oshu-samples-v1.tar.bz2" samples-v1.tar.bz2
		tar xf samples-v1.tar.bz2
	)
}
