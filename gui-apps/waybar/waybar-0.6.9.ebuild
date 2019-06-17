# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Highly customizable Wayland bar for Sway and Wlroots based compositors."
HOMEPAGE="https://github.com/Alexays/Waybar"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Alexays/Waybar.git"
else
	SRC_URI="https://github.com/Alexays/Waybar/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="mpd network pulseaudio tray udev"
S="$WORKDIR/Waybar-$PV"

DEPEND="
	dev-libs/libinput:=
	>=dev-libs/libfmt-5.3.0:=
	>=dev-libs/spdlog-1.3.1:=
	dev-libs/wayland:=
	dev-cpp/gtkmm:3.0=
	tray? (
		dev-libs/libdbusmenu:=[gtk3]
		dev-libs/glib:=
	)
	dev-libs/jsoncpp:=
	dev-libs/libsigc++:2=
	network? ( dev-libs/libnl:3= )
	pulseaudio? ( media-sound/pulseaudio:= )
	udev? ( virtual/udev )
	mpd? ( media-libs/libmpdclient:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature network libnl)
		$(meson_feature udev libudev)
		$(meson_feature pulseaudio)
		$(meson_feature tray dbusmenu-gtk)
		$(meson_feature mpd)
	)

	meson_src_configure
}
