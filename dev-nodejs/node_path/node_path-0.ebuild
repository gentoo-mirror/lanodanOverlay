# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Define NODE_PATH to /usr/share/nodejs/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

src_install() {
	newenvd - 99node_path <<< "NODE_PATH=/usr/share/nodejs/"
}
