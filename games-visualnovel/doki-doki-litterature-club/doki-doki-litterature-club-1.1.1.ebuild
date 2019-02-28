# Copyright 1999-2018 Gentoo Authors
# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

# Copied from katawa-shoujo-1.3.1.ebuild

EAPI=5

inherit eutils gnome2-utils

DESCRIPTION="Psychological horror game presented as a romance visual novel"
HOMEPAGE="https://ddlc.moe/"
SRC_URI="${P}.zip"
RESTRICT="bindist fetch"

# bundled renpy includes licenses of all libraries
LICENSE="all-rights-reserved
	!system-renpy? ( MIT PSF-2 LGPL-2.1 || ( FTL GPL-2+ ) IJG libpng ZLIB BZIP2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +system-renpy"

RDEPEND="system-renpy? ( games-engines/renpy )"

REQUIRED_USE="!system-renpy? ( || ( amd64 x86 ) )"

# Binaries are built extremely weirdly, resulting in errors like:
# BFD: Not enough room for program headers, try linking with -N
#
# Technically, we could make this unconditional because there are no other
# binaries, but it's still good practice.
RESTRICT="!system-renpy? ( strip )"

QA_PREBUILT="/opt/${PN}/lib/*"

S="${WORKDIR}/DDLC-${PV}-pc"

pkg_nofetch() {
	einfo "Please download “DDLC (Windows) version ${PV}” on ${HOMEPAGE}"
	einfo "and save it as ${DISTDIR}/${SRC_URI}"
}

src_install() {
	if use system-renpy; then
		insinto "/usr/share/${PN}"
		doins -r game/.

		make_wrapper ${PN} "renpy '/usr/share/${PN}'"
	else
		insinto "/opt/${PN}"
		doins -r game localizations renpy "DDLC."{py,sh}

		local host="${CTARGET:-${CHOST}}"
		local arch="${host%%-*}"

		cd lib
		insinto "/opt/${PN}/lib"
		doins -r linux-${arch} pythonlib2.7
		cd ..

		fperms +x "/opt/${PN}/lib/linux-${arch}/"{python,"DDLC"} \
			"/opt/${PN}/DDLC."{py,sh}

		make_wrapper ${PN} "./DDLC.sh" "/opt/${PN}"
	fi

	make_desktop_entry ${PN} "DDLC"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
