# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.64.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://cgit.kde.org/breeze.git"
LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="kwin"

RDEPEND="kwin? ( >=kde-plasma/kdecoration-${PVCUT}:5 )"
DEPEND="${RDEPEND}
	>=kde-frameworks/kpackage-${KFMIN}:5
"

src_configure() {
	local mycmakeargs=(
		-DWITH_DECORATIONS="$(usex kwin)"
	)
	ecm_src_configure
}
