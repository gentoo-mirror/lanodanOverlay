# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6} )

inherit python-single-r1

DESCRIPTION="Shell tool to control some Freebox OS stuff: wifi, reboot..."
HOMEPAGE="https://github.com/skimpax/fbxosctrl"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
SRC_URI="
	https://github.com/skimpax/fbxosctrl/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/wiki/skimpax/fbxosctrl/Mise-en-oeuvre-de-fbxosctrl.md -> fbxosctrl-lisezmoi.md
"

DEPEND="
	${PYTHON_DEPS}
	dev-python/requests[${PYTHON_USEDEP}]
"

DOCS=("${DISTDIR}/fbxosctrl-lisezmoi.md")

src_install() {
	default
	python_doexe fbxosctrl.py
}
