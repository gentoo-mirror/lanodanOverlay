# Copyright 2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="kconfig frontends and parser, including kconfig-tweak"
HOMEPAGE="https://bitbucket.org/nuttx/tools/src/master/kconfig-frontends/"
SRC_URI="
	https://bitbucket.org/nuttx/tools/downloads/${P}.tar.bz2
	https://deb.debian.org/debian/pool/main/k/kconfig-frontends/kconfig-frontends_${PV}+dfsg-6.debian.tar.xz
"
LICENSE="GPL-2" # GPL-2.0-only
SLOT="0"

KEYWORDS="~amd64"

IUSE="gtk nls qt"

# ncurses is technically optional
RDEPEND="
	sys-libs/ncurses:=
	nls? ( sys-devel/gettext )
	gtk? (
		x11-libs/gtk+:3
		dev-libs/glib
		gnome-base/libglade:2.0
	)
	qt? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"

PATCHES=(
	"${WORKDIR}/debian/patches/autoconf_270p.patch"
	"${WORKDIR}/debian/patches/gtk3.patch"
	"${WORKDIR}/debian/patches/python3_support.patch"
	"${WORKDIR}/debian/patches/gperf_newtype.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk gconf) \
		$(use_enable nls L10n) \
		$(use_enable qt qconf)
}
