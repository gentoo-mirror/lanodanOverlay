# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="Single Window Launcher for WPE WebKit"
HOMEPAGE="https://github.com/Igalia/cog"
EGIT_REPO_URI="https://github.com/Igalia/cog.git"
LICENSE="MIT"
SLOT="0"
IUSE="+drm gtk4 headless wayland X"

# note: cogcore_dep is ./core/
cogplatformcommon_dep="media-libs/libepoxy"
wpebackend_fdo_dep=">=gui-libs/wpebackend-fdo-1.8.0"

DEPEND="
	net-libs/wpewebkit:1.1=[X?]
	net-libs/libsoup:3.0
	drm? (
		${cogplatformcommon_dep}
		${wpebackend_fdo_dep}
		>=x11-libs/libdrm-2.4.71
		dev-libs/libinput:=
		virtual/libudev:=
	)
	gtk4? (
		${cogplatformcommon_dep}
		${wpebackend_fdo_dep}
		gui-libs/gtk:4
	)
	headless? ( ${wpebackend_fdo_dep} )
	wayland? (
		${wpebackend_fdo_dep}
		x11-libs/cairo
		media-libs/mesa[egl(+)]
		dev-libs/wayland
		dev-libs/wayland-protocols
		x11-libs/libxkbcommon
	)
	X? (
		${wpebackend_fdo_dep}
		${cogplatformcommon_dep}
		media-libs/mesa[egl(+)]
		x11-libs/libxcb
		x11-libs/libxkbcommon[X]
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson-format-array
	wayland? ( dev-util/wayland-scanner )
"

src_configure() {
	local platforms=(
		$(usev drm)
		$(usev headless)
		$(usev wayland)
		$(usev gtk4)
	)
	use X && platforms+=( 'x11' )

	local emesonargs=(
		-Dsoup2=disabled
		-Dplatforms="$(meson-format-array ${platforms[@]})"
		-Dwayland_weston_direct_display=false
		-Dwayland_weston_content_protection=false
	)

	meson_src_configure
}
