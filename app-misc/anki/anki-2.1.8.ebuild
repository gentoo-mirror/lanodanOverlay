# Copyright 1999-2018 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
SRC_URI="https://apps.ankiweb.net/downloads/current/${P}-source.tgz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex +recording +sound test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[gui,svg,webengine,widgets,${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	recording? (
		media-sound/lame
		>=dev-python/pyaudio-0.2.4[${PYTHON_USEDEP}]
	)
	sound? ( media-video/mpv )
	latex? (
		app-text/texlive
		app-text/dvipng
	)
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}"/${PN}-2.1.0_beta25-web-folder.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	sed -i "s/updates=True/updates=False/" aqt/profiles.py || die
	sed -i "s;share/doc/anki;share/doc/${P};" Makefile || die
}

src_compile() {
	./tools/build_ui.sh || die
}

src_test() {
	sed "s:nosetests:${EPYTHON} ${EROOT}usr/bin/nosetests:" -i tools/tests.sh || die
	./tools/tests.sh || die
}
