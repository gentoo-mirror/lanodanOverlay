# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Minimal seat management daemon and universal library"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/seatd"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/seatd"
else
	KEYWORDS="~amd64"
	SRC_URI="https://git.sr.ht/~kennylevinsen/seatd/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
LICENSE="MIT"
SLOT="0/1"
IUSE="examples logind"

DEPEND="logind? ( || ( sys-auth/elogind sys-apps/systemd ) )"
RDEPEND="${DEPEND}"
BDEPEND="app-text/scdoc"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		$(meson_feature examples)
		$(meson_feature logind)
	)

	meson_src_configure
}
