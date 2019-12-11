# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="remove binary blobs from a directory"
HOMEPAGE="https://hacktivis.me/git/go-deblob/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc ~x86"

EGIT_REPO_URI="https://hacktivis.me/git/go-deblob.git"
EGIT_MIN_CLONE_TYPE="single+tags"

DEPEND="dev-lang/go:0"
RDEPEND="${DEPEND}"

src_compile() {
	emake PREFIX="/usr"
}
