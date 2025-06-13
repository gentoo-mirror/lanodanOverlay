# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Single UNIX Specification, Version 2, 1997 Edition"
HOMEPAGE="https://www2.opengroup.org/ogsys/catalog/T101"
SRC_URI="https://pubs.opengroup.org/onlinepubs/007908799/download/susv2.tar.bz2"
S="${WORKDIR}/susv2"

LICENSE="sus2-copyright"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
RESTRICT="mirror"

src_install() {
	dodoc -r *
}
