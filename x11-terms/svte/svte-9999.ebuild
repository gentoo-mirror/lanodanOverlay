# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Simple-ass VTE-based (I know) terminal"
HOMEPAGE="https://hacktivis.me/git/svte/"
EGIT_REPO_URI="https://hacktivis.me/git/svte.git"
EGIT_MIN_CLONE_TYPE="single+tags"

LICENSE="CC-BY-SA-4.0"
SLOT="0"

DEPEND="
	x11-libs/vte
	x11-libs/gtk+:3=
"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="${CC:-cc}" \
		CFLAGS="${CFLAGS:--02 -Wall -Wextra}" \
		LDFLAGS="${LDFLAGS}" \
		PREFIX="/usr"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		install

	einstalldocs
}
