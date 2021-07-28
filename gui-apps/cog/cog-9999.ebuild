# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Single Window Launcher for WPE WebKit"
HOMEPAGE="https://github.com/Igalia/cog"
EGIT_REPO_URI="https://github.com/Igalia/cog.git"
LICENSE="MIT"
SLOT="0"
IUSE="+drm +fdo gtk4 headless X"

DEPEND="
	net-libs/wpewebkit
	net-libs/libsoup:2
	drm? (
		media-libs/mesa[egl,gbm]
		>=gui-libs/wpebackend-fdo-1.4.0
		>=x11-libs/libdrm-2.4.71
		dev-libs/libinput:=
		virtual/libudev:=
		dev-libs/wayland
	)
	fdo? (
		x11-libs/cairo
		media-libs/mesa[egl]
		>=gui-libs/wpebackend-fdo-1.6.0
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	gtk4? (
		gui-libs/gtk:4
		>=gui-libs/wpebackend-fdo-1.6.0
	)
	headless? ( >=gui-libs/wpebackend-fdo-1.8.0 )
	X? (
		>=gui-libs/wpebackend-fdo-1.6.0
		media-libs/mesa[egl]
		x11-libs/libxcb
		x11-libs/libxkbcommon[X]
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local ecmakeargs=(
		-DCOG_PLATFORM_DRM=$(usex drm)
		-DCOG_PLATFORM_HEADLESS=$(usex headless)
		-DCOG_PLATFORM_FDO=$(usex fdo)
		-DCOG_PLATFORM_X11=$(usex X)
		-DCOG_PLATFORM_GTK4=$(usex gtk4)
		-DCOG_WESTON_DIRECT_DISPLAY=off
		-DBUILD_DOCS=off
		-DUSE_SOUP2=on
	)

	cmake_src_configure
}
