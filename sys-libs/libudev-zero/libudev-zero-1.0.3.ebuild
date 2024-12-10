# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Daemonless replacement for libudev"
HOMEPAGE="https://github.com/illiliti/libudev-zero"
SRC_URI="https://github.com/illiliti/libudev-zero/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs"

RDEPEND="!sys-apps/systemd-utils[udev]"

src_compile() {
	emake libudev.so.1
	use static-libs && emake AR="$(tc-getAR)" libudev.a
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install-shared
	use static-libs && emake DESTDIR="${D}" PREFIX=/usr install-static
}
