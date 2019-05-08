# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A Qt5-based IM client for the Matrix protocol"
HOMEPAGE="https://github.com/QMatrixClient/Quaternion https://matrix.org/docs/projects/client/quaternion.html"
SRC_URI="https://github.com/QMatrixClient/Quaternion/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtwidgets:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtquickcontrols:5=
	dev-qt/qtscript:5=
	dev-qt/qtgui:5=
	dev-qt/linguist-tools:5=
	dev-qt/qtmultimedia:5=
	dev-qt/qtdbus:5=
	>=net-libs/libqmatrixclient-0.5.1:=
"
