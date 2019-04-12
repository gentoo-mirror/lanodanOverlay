# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig

if [[ "${PV}" == "9999" ]]
then
	EGIT_REPO_URI="https://hacktivis.me/git/badwolf.git"
	EGIT_MIN_CLONE_TYPE="single+tags"
	inherit git-r3
else
	MY_P="${PN}-$(ver_rs 3 - 4 .)"
	SRC_URI="https://hacktivis.me/releases/${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Minimalist and privacy-oriented WebKitGTK+ browser"
HOMEPAGE="https://hacktivis.me/git/badwolf"
LICENSE="BSD"
SLOT="0"

DOCS=("README.md" "KnowledgeBase.md")

DEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk
"

src_configure() {
	restore_config config.h
	default
}

src_compile() {
	emake \
		CC="${CC:-cc}" \
		CFLAGS="${CFLAGS:--02 -Wall -Wextra}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	save_config config.h
	einstalldocs
}
