# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A Qt5 library to write cross-platfrom clients for Matrix"
HOMEPAGE="https://github.com/QMatrixClient/libqmatrixclient https://matrix.org/docs/projects/sdk/libqmatrixclient.html"
SRC_URI="https://github.com/QMatrixClient/libqmatrixclient/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64"

DEPENDS="
	dev-qt/qtnetwork:5=
	dev-qt/qtgui:5=
"
