# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A minimalist image viewer using raw XLib."
HOMEPAGE="http://www.johnhawthorn.com/meh"
SRC_URI="http://web.uvic.ca/~jhawthor/${P}.tar.gz"

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
