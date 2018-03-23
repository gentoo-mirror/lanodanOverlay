# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="osu-skin? ( https://www.mg0.fr/oshu/skins/osu-v1.tar.gz -> ${PN}-skin-v1.tar.gz )"
KEYWORDS=""
LICENSE="GPL-3 CC-BY-NC-4.0"
SLOT="0"
IUSE="libav osu-skin"

EGIT_REPO_URI="https://github.com/fmang/oshu.git"
CMAKE_MIN_VERSION="3.9.0"

RDEPEND="
	>=media-libs/libsdl2-2.0.5:=
	media-libs/sdl2-image:=[jpeg,png]
	x11-libs/cairo:=
	x11-libs/pango:=
	!libav? ( media-video/ffmpeg:= )
	libav? ( media-video/libav:= )
"

DEPEND="
	${RDEPEND}
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
		cp "${DISTDIR}/${PN}-skin-v1.tar.gz" "${BUILD_DIR}/share/skins/osu.tar.gz" || die
	fi

	default
}
pkg_postinst() {
        xdg_desktop_database_update
        xdg_mimeinfo_database_update
}

pkg_postrm() {
        xdg_desktop_database_update
        xdg_mimeinfo_database_update
}
