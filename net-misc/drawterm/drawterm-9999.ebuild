# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils mercurial

DESCRIPTION="connect to Plan 9 CPU servers from other operating systems"
HOMEPAGE="http://drawterm.9front.org/"
LICENSE="9base MIT"
SLOT="9front"
SRC_URI=""
EHG_REPO_URI="https://code.9front.org/hg/drawterm"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="x11-base/xorg-server"

src_compile() {
	export CONF=unix
	default
}

src_install() {
	dobin drawterm
}
