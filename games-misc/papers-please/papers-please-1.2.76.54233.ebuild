# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A Dystopian Document Thriller"
HOMEPAGE="https://www.gog.com/game/papers_please https://papersplea.se/"
SRC_URI="papers_please_1_2_76_54233.sh"
S="${WORKDIR}"

LICENSE="PAPERS-PLEASE"
SLOT="0"
KEYWORDS="~amd64"

dir="/opt/${PN}"

RESTRICT="bindist fetch strip"
QA_PREBUILT="opt/${PN}/*"

BDEPEND="app-arch/unzip"

pkg_nofetch() {
	einfo
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your DISTDIR directory."
	einfo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${dir}"
	doexe data/noarch/game/PapersPlease
	dosym "${dir}/PapersPlease" "/usr/bin/${PN}"

	insinto ${dir}
	doins -r data/noarch/game/loc/
	doins -r data/noarch/game/assets/
}
