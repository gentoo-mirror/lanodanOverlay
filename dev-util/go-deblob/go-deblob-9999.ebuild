# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="hacktivis.me/git/go-deblob"

inherit git-r3 go-module

DESCRIPTION="remove binary blobs from a directory"
HOMEPAGE="https://hacktivis.me/git/go-deblob/"
# BSD: hacktivis.me/git/go-deblob, git.sr.ht/~sircmpwn/getopt
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc ~x86"

EGIT_REPO_URI="https://hacktivis.me/git/go-deblob.git"
EGIT_MIN_CLONE_TYPE="single+tags"

src_unpack() {
	git-r3_src_unpack

	# Hotfix against go-module.eclass
	mkdir "${S}/vendor"
	go-module_live_vendor
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	einstalldocs
}
