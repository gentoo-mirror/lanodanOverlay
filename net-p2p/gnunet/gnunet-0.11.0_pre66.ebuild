# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

MY_PV="0.11.0pre66"

DESCRIPTION="GNUnet is a framework for secure peer-to-peer networking."
HOMEPAGE="http://gnunet.org/"
LICENSE="GPL-3"
SRC_URI="mirror://gnu/${PN}/${PN}-${MY_PV}.tar.gz"
KEYWORDS="~amd64"
SLOT="0"
IUSE="experimental http mysql postgres nls +sqlite X"
REQUIRED_USE="|| ( mysql postgres sqlite )"

S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND="
	>=net-misc/curl-7.21.0
	>=media-libs/libextractor-0.6.1
	dev-libs/libgcrypt
	>=dev-libs/libunistring-0.9.2
	sys-libs/ncurses
	sys-libs/zlib
	http? ( >=net-libs/libmicrohttpd-0.9.18 )
	mysql? ( >=virtual/mysql-5.1 )
	postgres? ( dev-db/postgresql )
	nls? ( sys-devel/gettext )
	sqlite? ( >=dev-db/sqlite-3.0 )
	X? (
		x11-libs/libXt
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXrandr
	)
"

pkg_setup() {
	enewgroup gnunetdns
	enewuser  gnunet
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable nls) \
		$(use_enable experimental) \
		$(use_with http microhttpd) \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		$(use_with sqlite) \
		$(use_with X x)
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	newinitd "${FILESDIR}"/${PN}-9999.initd gnunet
	keepdir /var/{lib,log}/gnunet
	fowners gnunet:gnunet /var/lib/gnunet /var/log/gnunet
}

pkg_postinst() {
	einfo
	einfo "To configure"
	einfo "	 1) Add user(s) to the gnunet group"
	einfo "	 2) Edit the server config file '/etc/gnunet.conf'"
	einfo
}
