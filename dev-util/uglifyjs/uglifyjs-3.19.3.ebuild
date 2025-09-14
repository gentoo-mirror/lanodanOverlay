# Copyright 1999-2022 Gentoo Authors
# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

MY_PN="UglifyJS"
DESCRIPTION="JavaScript parser, minifier, compressor and beautifier toolkit"
HOMEPAGE="https://lisperator.net/uglifyjs/"
SRC_URI="https://github.com/mishoo/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-nodejs/semver )"
RDEPEND="net-libs/nodejs"
BDEPEND="sys-apps/help2man"

DOCS=( README.md )

NPM_FLAGS=(
	--audit false
	--color false
	--foreground-scripts
	--global
	--offline
	--progress false
	--save false
	--verbose
)

src_prepare() {
	default

	# One doesn't simply packages acorn
	rm test/mocha/exports.js test/mocha/imports.js || die
}

src_compile() {
	help2man -s1 -o uglifyjs.1 -N ./bin/uglifyjs || die
	npm "${NPM_FLAGS[@]}" pack || die
}

src_install() {
	einstalldocs
	doman uglifyjs.1
	npm "${NPM_FLAGS[@]}" \
		--prefix "${ED}"/usr \
		install \
		uglify-js-${PV}.tgz || die
}
