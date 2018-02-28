# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="osu-skin? ( https://www.mg0.fr/oshu/skins/osu-v1.tar.gz -> ${PN}-v1.tar.gz )"
KEYWORDS=""
LICENSE="GPL-3 CC-BY-NC-4.0"
SLOT="0"
IUSE="osu-skin"

EGIT_REPO_URI="https://github.com/fmang/oshu.git"
CMAKE_MIN_VERSION="3.9.0"

RDEPENDS="
	media-libs/libsdl2:=
	media-libs/sdl2-image:=
	x11-libs/cairo:=
	x11-libs/pango:=
	|| (
		media-video/ffmpeg:=
		media-video/libav:=
	)"

DEPENDS="
	${RDEPENDS}
	virtual/pkgconfig
	"

src_configure() {
	if use osu-skin; then
		local mycmakeargs=(
			"-DOSHU_DEFAULT_SKIN=osu"
			"-DOSHU_SKINS=osu;minimal"
		)
	else
		# default values; I prefer to be sure
		local mycmakeargs=(
			"-DOSHU_DEFAULT_SKIN=minimal"
			"-DOSHU_SKINS=minimal"
		)
	fi	

	cmake-utils_src_configure
}

src_compile() {
	if use osu-skin; then
		mkdir -p "${BUILD_DIR}/share/skins" || die
		cp "${DISTDIR}/${PN}-v1.tar.gz" "${BUILD_DIR}/share/skins/osu.tar.gz" || die
	fi

	default
}
