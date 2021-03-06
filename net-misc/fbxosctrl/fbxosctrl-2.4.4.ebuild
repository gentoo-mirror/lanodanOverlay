# Copyright 2018-2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1

DESCRIPTION="Shell tool to control some Freebox OS stuff: wifi, reboot..."
HOMEPAGE="https://github.com/skimpax/fbxosctrl"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
SRC_URI="https://github.com/skimpax/fbxosctrl/archive/${PV}.tar.gz -> ${P}.tar.gz"

DEPEND="
	${PYTHON_DEPS}
	dev-python/requests[${PYTHON_USEDEP}]
"

DOCS=("${DISTDIR}/fbxosctrl-lisezmoi.md")

src_install() {
	default
	python_doexe fbxosctrl.py
}

pkg_install() {
	emessage "Pour la mise en place, voir: https://raw.githubusercontent.com/wiki/skimpax/fbxosctrl/Mise-en-oeuvre-de-fbxosctrl.md"
}
