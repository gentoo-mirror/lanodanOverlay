# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils libtool toolchain-funcs autotools flag-o-matic

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

# OpenBSD patches may be under the ISC
LICENSE="GPL-2 ISC"

# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="debug ipv6 libressl ssl test"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/libsigc++-2.2.2:2
	ssl? (
	    !libressl? ( dev-libs/openssl:0= )
	    libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cppunit )"

src_prepare() {
	# I should probably move it to a PATCHES variable

	# Fix compiling with Clang by being C++11
	append-cxxflags "-std=c++11"
	find "${WORKDIR}" -type f|xargs fgrep -lw tr1|xargs sed -i -e 's,<tr1/,<,' -e 's/std::tr1/std/g'
	epatch "${FILESDIR}/libtorrent-0.13.6-clangpatch-src_utils_queue_buckets_h.patch"
	epatch "${FILESDIR}/libtorrent-0.13.6-clangpatch-src_torrent_utils_log_cc.patch"
	epatch "${FILESDIR}/libtorrent-0.13.6-configure.ac_cppunit_use_pkg-config.patch"
	epatch "${FILESDIR}/libtorrent-0.13.6-patch-src_utils_instrumentation_h.patch"
	epatch "${FILESDIR}/libtorrent-0.13.6-patch-src_torrent_utils_extents_h.patch"
	epatch "${FILESDIR}/libtorrent-0.13.6-patch-src_net_socket_set_h.patch"

	# Fixes a unassigned warning for a happy QA
	epatch "${FILESDIR}/libtorrent-0.13.6-src_dht_dht_transaction_cc.patch"

	eautoreconf
	default
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		--disable-instrumentation \
		--with-posix-fallocate
}

src_install() {
	default

	prune_libtool_files --all
}
