# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A GTK/Pango-based terminal that uses libvterm to provide terminal emulation"
HOMEPAGE="http://www.leonerd.org.uk/code/pangoterm/"
SRC_URI="https://bazaar.launchpad.net/~leonerd/pangoterm/trunk/tarball/616 -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-libs/libvterm-0.1.3
	x11-libs/cairo:=
	x11-libs/gtk+:2=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/~leonerd/pangoterm/trunk/"

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	dodoc pangoterm.cfg
}
