# Copyright 1999-2017 Gentoo Foundation
# Copyright 2017-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P="Cockatrice-2018-12-20-Release-${PV}"

DESCRIPTION="An open-source multiplatform software for playing card games over a network"
HOMEPAGE="https://github.com/Cockatrice/Cockatrice"

SRC_URI="https://github.com/Cockatrice/Cockatrice/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client server +oracle nls"

DEPEND="
	dev-libs/protobuf:=
	nls? ( dev-qt/linguist-tools:5= )
	client? (
		dev-qt/qtconcurrent:5=
		dev-qt/qtmultimedia:5=
		dev-qt/qtnetwork:5=
		dev-qt/qtprintsupport:5=
		dev-qt/qtsvg:5=
		dev-qt/qtwidgets:5=
	)
	server? (
		dev-qt/qtnetwork:5=
		dev-qt/qtsql:5=
		# soft-deps follows
		dev-qt/qtwebsockets:5=
	)
	oracle? (
		dev-qt/qtconcurrent:5=
		dev-qt/qtnetwork:5=
		dev-qt/qtsvg:5=
		dev-qt/qtwidgets:5=
		# soft-deps follows
		sys-libs/zlib:5=
	)
"

src_configure() {
	local mycmakeargs=(
		-DWITH_CLIENT="$(usex client)"
		-DWITH_SERVER="$(usex server)"
		-DWITH_ORACLE="$(usex oracle)"
		-DICONDIR="/usr/share/icons"
		-DDESKTOPDIR="/usr/share/applications"
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	#FIXME:
	elog "zonebg pictures are in ${GAMES_DATADIR}/${PN}/zonebg"
	elog "sounds are in ${GAMES_DATADIR}/${PN}/sounds"
	elog "you can use those directories in cockatrice settings"
}
