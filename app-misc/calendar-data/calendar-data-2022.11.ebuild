# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="data files for calendar(1) utility"
HOMEPAGE="https://github.com/freebsd/calendar-data"
SRC_URI="https://github.com/freebsd/calendar-data/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!app-misc/calendar"

src_install() {
	insinto /usr/share/calendar
	doins calendar.*
	doins -r *.UTF-8/
}
