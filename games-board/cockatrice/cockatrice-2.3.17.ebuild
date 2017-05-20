# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils

DESCRIPTION="An open-source multiplatform software for playing card games over a network"
HOMEPAGE="https://github.com/Cockatrice/Cockatrice"

SRC_URI="https://github.com/Cockatrice/Cockatrice/archive/2017-05-05-Release-2.3.17.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/"Cockatrice-2017-05-05-Release-2.3.17"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated server nls"

DEPEND="
	dev-libs/protobuf
	nls? ( dev-qt/linguist-tools:5 )
	dev-qt/qtwidgets:5
	dev-qt/qtwebsockets:5
	!dedicated? (
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtsvg:5
	)"

src_configure() {
	local mycmakeargs=(
		$(usex dedicated "-DWITHOUT_CLIENT=1 -DWITH_SERVER=1" "$(usex server "-DWITH_SERVER=1" "")")
		-DICONDIR="/usr/share/icons"
		-DDESKTOPDIR="/usr/share/applications"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	#FIXME:
	elog "zonebg pictures are in ${GAMES_DATADIR}/${PN}/zonebg"
	elog "sounds are in ${GAMES_DATADIR}/${PN}/sounds"
	elog "you can use those directories in cockatrice settings"
}
