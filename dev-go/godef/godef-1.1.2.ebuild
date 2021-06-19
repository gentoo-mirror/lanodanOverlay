# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="detect licenses used in Go binaries"
HOMEPAGE="https://github.com/mitchellh/golicense"

EGO_SUM=(
	"9fans.net/go v0.0.0-20181112161441-237454027057"
	"9fans.net/go v0.0.0-20181112161441-237454027057/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee"
	"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20200226224502-204d844ad48d"
	"golang.org/x/tools v0.0.0-20200226224502-204d844ad48d/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
)
go-module_set_globals
SRC_URI="https://github.com/rogpeppe/godef/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

src_compile() {
	go build || die
}

src_install() {
	default
	dobin ${PN}
}
