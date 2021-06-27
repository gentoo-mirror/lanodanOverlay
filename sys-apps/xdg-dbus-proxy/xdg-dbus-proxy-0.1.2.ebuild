# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="filtering proxy for D-Bus connections"
HOMEPAGE="https://github.com/flatpak/xdg-dbus-proxy"
LICENSE="LGPL-2.1"
SRC_URI="https://github.com/flatpak/xdg-dbus-proxy/releases/download/${PV}/${P}.tar.xz"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390  ~sparc ~x86"

DEPEND="
	>=dev-libs/glib-2.40
	dev-libs/libxslt
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/xdg-dbus-proxy-0.1.2_temp_failure_retry.patch" )

src_configure() {
	econf --enable-man
}
