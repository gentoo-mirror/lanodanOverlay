# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Define GOPATH to /usr/src/go to install sources of Go libraries"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_install() {
	newenvd - 99gopath <<< "GOPATH=/usr/src/go"
}
