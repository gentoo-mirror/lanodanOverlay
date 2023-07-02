# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://hacktivis.me/git/rc-status-page.git"

DESCRIPTION="Basic HTML status page based on OpenRC"
HOMEPAGE="https://hacktivis.me/git/rc-status-page.git"
LICENSE="BSD-2"
SLOT="0"

DEPEND="sys-apps/openrc:="
RDEPEND="${DEPEND}"

src_install() {
	dodoc rc-status-page.css
	dobin rc-status-page
}
