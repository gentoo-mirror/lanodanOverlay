# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="simple web browser using GTK+ 3, GLib and WebKit2GTK+"
HOMEPAGE="https://uninformativ.de/git/lariza"
EGIT_REPO_URI="https://www.uninformativ.de/git/lariza.git"
EGIT_COMMIT="42ab1d83c804d950e41f1dfe55bacb939844c637"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=("CHANGES" "README" "PATCHES")

DEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk
"

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install
}
