# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DV="20121020"
MY_PN="fcitx5"
DESCRIPTION="Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5"
SRC_URI="
	https://github.com/fcitx/fcitx5/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://download.fcitx-im.org/data/en_dict-${DV}.tar.gz -> fcitx-data-en_dict-${DV}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="X coverage dbus doc +emoji +enchant +keyboard +libuuid +server systemd test wayland"
REQUIRED_USE="coverage? ( test )"
RESTRICT="!test? ( test )"

DEPEND="
	X? (
		dev-libs/glib:2
		x11-libs/cairo[X]
		x11-libs/gdk-pixbuf:2
		x11-libs/libxcb[xkb]
		x11-libs/libxkbfile
		x11-libs/pango[X]
		x11-libs/xcb-util
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-wm
		)
	dev-libs/libfmt
	emoji? (
		app-i18n/unicode-cldr
		dev-libs/expat
		)
	enchant? ( app-text/enchant:2 )
	keyboard? (
		app-text/iso-codes
		dev-libs/expat
		dev-libs/json-c
		x11-libs/libxkbcommon[X?]
		x11-misc/xkeyboard-config
		)
	libuuid? ( sys-apps/util-linux )
	sys-devel/gettext
	systemd? ( sys-apps/systemd )
	!systemd? (
		dbus? ( sys-apps/dbus )
		dev-libs/libevent
		)
	virtual/libintl
	wayland? (
		dev-libs/glib:2
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/pango
		)
"
RDEPEND="${DEPEND}
"
BDEPEND="
	doc? ( app-text/doxygen )
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

#	"${FILESDIR}/${PN}-5.0.8-fix-conflicts-with-fcitx4.diff"
PATCHES=( )

src_prepare() {
	cp "${DISTDIR}/fcitx-data-en_dict-${DV}.tar.gz" src/modules/spell/en_dict-${DV}.tar.gz || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TEST=$(usex test)
		-DENABLE_COVERAGE=$(usex coverage)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_X11=$(usex X)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_SERVER=$(usex server)
		-DENABLE_KEYBOARD=$(usex keyboard)
		-DENABLE_EMOJI=$(usex emoji)
		-DENABLE_LIBUUID=$(usex libuuid)
		-DENABLE_DOC=$(usex doc)
		-DUSE_SYSTEMD=$(usex systemd)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
