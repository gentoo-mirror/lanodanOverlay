# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="JavaScript parser, mangler/compressor and beautifier toolkit"
HOMEPAGE="http://lisperator.net/uglifyjs"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs[npm]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	npm install -g --user root --prefix "${D}/usr" "${DISTDIR}/${P}.tgz" || die "npm install failed"

	# fix npm derp
	find "${D}/usr" -type d -exec chmod 755 '{}' +
}
