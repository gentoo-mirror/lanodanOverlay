# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A minimalist image viewer using raw XLib."
HOMEPAGE="http://www.johnhawthorn.com/meh"
EGIT_REPO_URI="git://github.com/jhawthorn/meh.git http://github.com/jhawthorn/meh.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-libs/libXext
	virtual/jpeg:*
	media-libs/giflib
	media-libs/libpng:*"
RDEPEND="${DEPEND}"
