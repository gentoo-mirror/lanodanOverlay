# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="wgetpaste clone for pushing to your own server"
HOMEPAGE="https://hacktivis.me/git/sshpaste/"
SRC_URI="https://distfiles.hacktivis.me/releases/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="X"

DEPEND=""
RDEPEND="
	${DEPEND}
	virtual/ssh
	X? ( x11-misc/xclip )
"

src_install() {
	dodoc README.md
	dodoc Changelog.md
	dobin sshpaste
}
