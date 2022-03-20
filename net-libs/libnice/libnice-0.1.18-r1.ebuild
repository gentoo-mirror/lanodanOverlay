# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson-multilib xdg

DESCRIPTION="An implementation of the Interactice Connectivity Establishment standard (ICE)"
HOMEPAGE="https://nice.freedesktop.org/wiki/"
SRC_URI="https://nice.freedesktop.org/releases/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+gnutls gstreamer +introspection +upnp"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	gnutls? ( >=net-libs/gnutls-2.12.0:0=[${MULTILIB_USEDEP}] )
	!gnutls? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	upnp? ( >=net-libs/gupnp-igd-0.2.4:=[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
		!<media-plugins/gst-plugins-libnice-0.1.18-r1
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

multilib_src_configure() {
	local emesonargs=(
		-Dcrypto-library=$(usex gnutls gnutls openssl)
		$(meson_native_use_feature introspection)
		$(meson_feature upnp gupnp)
		$(meson_feature gstreamer)
	)

	meson_src_configure

	#if multilib_is_native_abi; then
	#	ln -s {"${S}"/,}docs/reference/libnice/html || die
	#fi
}

multilib_src_install_all() {
	einstalldocs
}
