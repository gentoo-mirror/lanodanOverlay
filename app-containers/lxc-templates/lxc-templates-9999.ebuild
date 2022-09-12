# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="Old style template scripts for LXC"
HOMEPAGE="https://linuxcontainers.org/ https://github.com/lxc/lxc-templates"
EGIT_REPO_URI="https://github.com/lxc/lxc-templates.git"
LICENSE="LGPL-3"
SLOT="0"

RDEPEND=">=app-containers/lxc-3.0"
DEPEND="${RDEPEND}"

DOCS=()

src_prepare() {
	default

	sed -i '/^install-data-local:/,/^$/d' Makefile.am || die

	eautoreconf
}
