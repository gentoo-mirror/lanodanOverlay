# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Make pointer-driven interfaces easier and faster for users to operate"
HOMEPAGE="https://github.com/jordansissel/keynav"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jordansissel/keynav.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/cairo:=[X]
	dev-libs/glib:=
	x11-libs/libXinerama:="
RDEPEND="${DEPEND}
	x11-misc/xdotool"

DOCS="README CHANGELIST keynavrc"

src_install() {
	dobin keynav
	einstalldocs
}
