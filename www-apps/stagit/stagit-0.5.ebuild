# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="static git page generator"
HOMEPAGE="http://git.2f30.org/stagit"
SRC_URI="http://dl.2f30.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libgit2"
RDEPEND="${DEPEND}"

src_configure() {
	sed -i "s/PREFIX =.*/PREFIX ?= ${EPREFIX}/" "${S}/config.mk"
	sed -i "s/#CC =.*/CC ?= ${CC:-cc}/" "${S}/config.mk"
}
