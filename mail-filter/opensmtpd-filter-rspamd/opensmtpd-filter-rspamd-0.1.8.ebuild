# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/poolpOrg/filter-rspamd"

DESCRIPTION="OpenSMTPD filter for putting emails through rspamd"
HOMEPAGE="https://github.com/poolpOrg/filter-rspamd"
SRC_URI="https://github.com/poolpOrg/filter-rspamd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/src/${EGO_PN}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/go-1.15
	>=dev-go/sys-0.13.0
"
RDEPEND="${DEPEND} mail-mta/opensmtpd"
BDEPEND=""

RESTRICT="strip"
QA_FLAGS_IGNORED='.*'

DOCS=( README.md )

src_unpack() {
	default

	mkdir -p "$(dirname "${S}")" || die
	mv "${WORKDIR}/filter-rspamd-${PV}" "${S}" || die
}

src_compile() {
	# disable module-aware mode
	export GO111MODULE=off
	# no network access
	export GOPROXY=off
	# don't try to update the toolchain
	export GOTOOLCHAIN="local"

	# With GO111MODULE=off WORKDIR needs to be included
	export GOPATH="${WORKDIR}:${EPREFIX}/usr/lib/go-gentoo"

	go build -ldflags="-s -w" -buildmode=pie -o filter-rspamd || die
}

src_install() {
	default
	exeinto /usr/libexec/opensmtpd
	doexe filter-rspamd
}
