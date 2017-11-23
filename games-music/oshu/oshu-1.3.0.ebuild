# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="https://www.mg0.fr/oshu/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

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
