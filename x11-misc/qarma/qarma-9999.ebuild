# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils

DESCRIPTION="Zenity Clone for Qt5 (lanodan's branch)"
HOMEPAGE="https://github.com/lanodan/qarma"
EGIT_REPO_URI="https://github.com/lanodan/qarma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dbus? ( dev-qt/qtdbus:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 $(usex dbus "" "CONFIG+=DISABLE_DBUS")
}
