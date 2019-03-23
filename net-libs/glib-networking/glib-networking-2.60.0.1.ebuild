# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/${PN}/"
SRC_URI="https://ftp.gnome.org/pub/GNOME/sources/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gnome gnutls +libproxy libressl +openssl test"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.55.1:2
	libproxy? ( >=net-libs/libproxy-0.3.1:= )
	gnutls? ( >=net-libs/gnutls-3.4.6:= )
	openssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature gnutls)
		$(meson_feature openssl)
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Dstatic_modules=false
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_giomodule_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_giomodule_cache_update
}
