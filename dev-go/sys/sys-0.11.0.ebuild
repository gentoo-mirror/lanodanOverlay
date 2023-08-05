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

src_install() {
	mkdir -p "$(dirname "${ED}/usr/lib/go-gentoo/src/${EGO_PN}")" || die
	cp -r "${P}" "${ED}/usr/lib/go-gentoo/src/${EGO_PN}" || die
	test -f "${ED}/usr/lib/go-gentoo/src/${EGO_PN}/go.mod" || die
}
