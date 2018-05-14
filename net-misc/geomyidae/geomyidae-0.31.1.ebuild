# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="A small C-based gopherd."
HOMEPAGE="gopher://bitreich.org/1/scm/geomyidae http://git.r-36.net/geomyidae/"
SRC_URI="http://git.r-36.net/geomyidae/snapshot/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xinetd"

DEPEND=""
RDEPEND="xinetd? ( virtual/inetd )"

pkg_setup() {
	enewgroup ${P}
	enewuser ${P} -1 -1 "/var/gopher" ${P}
}

src_install() {
	default

	if use xinetd
	then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/geomyidae.xinetd" ${PN}
	else
		newinitd "${FILESDIR}/geomyidae.initd" ${PN}
		elog "By default this init is using port 7000 and obfuscates to port 70 to avoid running as root."
		elog "This needs you to add a iptables rule to redirect 7000 to 70."
	fi
}
