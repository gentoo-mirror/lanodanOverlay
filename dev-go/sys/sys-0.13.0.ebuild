# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="golang.org/x/sys"

DESCRIPTION="supplemental Go packages for low-level interactions with the operating system"
HOMEPAGE="https://golang.org/x/sys"
SRC_URI="https://github.com/golang/sys/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-lang/go )"

src_prepare() {
	default

	mkdir -p "$(dirname "${WORKDIR}/src/${EGO_PN}")" || die
	mv "${S}/${P}" "${WORKDIR}/src/${EGO_PN}" || die
}

src_test() {
	# disable module-aware mode
	export GO111MODULE=off

	# With GO111MODULE=off WORKDIR needs to be included
	export GOPATH="${WORKDIR}:${EPREFIX}/usr/lib/go-gentoo"

	# `go test` doesn't recurses in directories by itself
	go test "${EGO_PN}/cpu" "${EGO_PN}/execabs" "${EGO_PN}/unix" || die
}

src_install() {
	mkdir -p "${ED}/usr/lib/go-gentoo/" || die
	cp -r "${WORKDIR}/src" "${ED}/usr/lib/go-gentoo/src" || die
	test -f "${ED}/usr/lib/go-gentoo/src/${EGO_PN}/go.mod" || die
}
