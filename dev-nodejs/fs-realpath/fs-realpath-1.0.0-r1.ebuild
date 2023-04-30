# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

MY_P=fs.realpath-${PV}

DESCRIPTION="Use node's fs.realpath, but fall back to the JS implementation if the native one fails"
HOMEPAGE="https://github.com/isaacs/fs.realpath"
SRC_URI="https://github.com/isaacs/fs.realpath/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
#DEPEND="test? ( dev-nodejs/tap )"

RESTRICT="test"

src_install() {
	insinto "${NODEJS_SITELIB}fs.realpath"
	doins package.json

	cat package.json | jq -r .files[] | while read pkg
	do
		doins -r "$pkg"
	done
}
