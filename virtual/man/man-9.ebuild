# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for man"
SLOT="0"
KEYWORDS="~amd64 ~arm"

RDEPEND="|| (
	app-text/mandoc
	sys-apps/man-db
	sys-apps/man
)"
