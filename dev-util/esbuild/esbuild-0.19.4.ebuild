# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/evanw/esbuild"

DESCRIPTION="extremely fast bundler for the web"
HOMEPAGE="https://esbuild.github.io/"
SRC_URI="https://github.com/evanw/esbuild/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/src/${EGO_PN}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	>=dev-lang/go-1.13
	dev-go/sys
	test? (
		net-libs/nodejs
		dev-nodejs/source-map-js
	)
"
BDEPEND="sys-apps/help2man"

RESTRICT="!test? ( test ) strip"
QA_FLAGS_IGNORED='.*'

src_unpack() {
	default

	mkdir -p "$(dirname "${S}")" || die
	mv "${WORKDIR}/${P}" "${S}" || die
}

src_prepare() {
	default

	# complex: Depends on fuse.js + react
	sed -i \
		-e "s;require('source-map');require('source-map-js');" \
		-e "/check('complex'/,/}),/d" \
		scripts/verify-source-map.js || die

	# No need to fetch dependencies via npm
	sed -i -e 's;cd scripts && npm ci;true;' Makefile || die
}

src_configure() {
	# disable module-aware mode
	export GO111MODULE=off
	# no network access
	export GOPROXY=off
	# don't try to update the toolchain
	export GOTOOLCHAIN="local"

	# With GO111MODULE=off WORKDIR needs to be included
	export GOPATH="${WORKDIR}:${EPREFIX}/usr/lib/go-gentoo"

	export EGO_BUILD_FLAGS="${EGO_BUILD_FLAGS} -trimpath"
}

src_test() {
	emake test
}

src_install() {
	set -- env GOBIN="${ED}/usr/bin" go install -v -work -x ${EGO_BUILD_FLAGS} ./cmd/esbuild
	echo "$@"
	"$@" || die

	help2man -s1 -o esbuild.1 -N "${ED}/usr/bin/esbuild" || die
	doman esbuild.1
}
