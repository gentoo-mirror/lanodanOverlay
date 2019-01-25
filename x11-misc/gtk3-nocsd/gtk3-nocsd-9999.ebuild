# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib git-r3

DESCRIPTION="A hack to disable gtk3 client-side decorations"
HOMEPAGE="https://github.com/naufalfachrian/gtk3-nocsd"

EGIT_REPO_URI="https://github.com/naufalfachrian/gtk3-nocsd.git"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
LICENSE="GPL-2"

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_install() {
	emake prefix="${D}/usr" libdir="${D}/usr/$(get_libdir)" install

	dodir /etc/env.d
	einfo "Add to your .profile:\nGTK_CSD=0\nLD_PRELOAD=${EROOT%/}/usr/$(get_libdir)/libgtk3-nocsd.so.0"
}
