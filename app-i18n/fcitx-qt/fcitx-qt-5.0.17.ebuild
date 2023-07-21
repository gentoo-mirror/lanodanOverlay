# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="fcitx5-qt"
DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-qt"
SRC_URI="https://github.com/fcitx/fcitx5-qt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="dbus only-plugin static-plugin X"
REQUIRED_USE="static-plugin? ( only-plugin )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	x11-libs/libxkbcommon
	!only-plugin? ( >=app-i18n/fcitx-5.0.16:5 )
	dbus? ( dev-qt/qtdbus:5 )
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	!only-plugin? ( sys-devel/gettext )
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/0001-CMake-Add-option-to-disable-X11-support.patch"
	"${FILESDIR}/0002-CMake-Add-option-to-disable-DBus-support.patch"
)

src_configure() {
	# gentoo only support qt5 officially, disable qt4 & qt6 for now
	local mycmakeargs=(
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_QT4=no
		-DENABLE_QT6=no
		-DENABLE_X11=$(usex X)
		-DBUILD_ONLY_PLUGIN=$(usex only-plugin)
		-DBUILD_STATIC_PLUGIN=$(usex static-plugin)
	)
	cmake_src_configure
}
