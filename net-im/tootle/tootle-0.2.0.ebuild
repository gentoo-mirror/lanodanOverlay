# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson vala gnome2-utils

DESCRIPTION="GTK3 client for Mastodon API"
HOMEPAGE="https://github.com/bleakgrey/tootle"
SRC_URI="https://github.com/bleakgrey/tootle/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/glib
	dev-libs/granite
	dev-libs/json-glib
	net-libs/libsoup:2.4
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"

src_prepare() {
	vala_src_prepare
	default
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_gconf_install
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
