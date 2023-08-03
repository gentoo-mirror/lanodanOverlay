# Copyright 2013-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

MY_P="fcitx5-anthy-${PV}"

DESCRIPTION="Japanese Anthy input methods for Fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-anthy"
#	verify-sig? ( https://download.fcitx-im.org/fcitx5/fcitx5-anthy/fcitx5-anthy-${PV}.tar.xz.sig )
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=app-i18n/fcitx-5.0.6:5
	app-i18n/anthy:=
	sys-devel/gettext
	virtual/libintl
"
RDEPEND="${DEPEND}"

DOCS=()

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
