# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils systemd flag-o-matic

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="daemon debug ipv6 selinux test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-0.13.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	# Fix compiling with Clang by being C++11
	append-cxxflags "-std=c++11"
	find "${WORKDIR}" -type f|xargs fgrep -lw tr1|xargs sed -i -e 's,<tr1/,<,' -e 's/std::tr1/std/g' -e 's/tr1::placeholders::/std::placeholders::/g' -e 's/tr1::bind/std::bind/g' || die
	epatch \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_core_manager_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_core_poll_manager_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_display_window_file_list_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_rpc_exec_file_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_rpc_object_storage_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-src_signal_handler_cc.patch" \
		"${FILESDIR}/rtorrent-0.9.6-patch-Makefile_in.patch"

	# bug #358271
	epatch \
		"${FILESDIR}"/${PN}-0.9.1-ncurses.patch \
		"${FILESDIR}"/${PN}-0.9.4-tinfo.patch \
		"${FILESDIR}"/${PN}-0.9.6-cppunit-pkgconfig.patch

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eapply_user

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
		systemd_newunit "${FILESDIR}/rtorrentd_at.service" "rtorrentd@.service"
	fi
}
