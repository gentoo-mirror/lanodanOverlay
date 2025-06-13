# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Single UNIX Specification, Version 3, 2004 Edition"
HOMEPAGE="https://www2.opengroup.org/ogsys/catalog/T101"
SRC_URI="https://pubs.opengroup.org/onlinepubs/009695399/download/susv3.tgz"
S="${WORKDIR}/susv3"

LICENSE="sus3-copyright"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
RESTRICT="mirror"

src_install() {
	dodoc -r *
}
