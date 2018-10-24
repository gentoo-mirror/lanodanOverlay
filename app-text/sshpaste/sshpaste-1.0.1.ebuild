# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="wgetpaste clone for pushing to your own server"
HOMEPAGE="https://hacktivis.me/git/sshpaste/"
SRC_URI="https://hacktivis.me/git/sshpaste/archives/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
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
