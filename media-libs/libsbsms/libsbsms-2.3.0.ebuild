# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for high quality time and pitch scale modification"
HOMEPAGE="https://github.com/claytonotey/libsbsms"
SRC_URI="https://github.com/claytonotey/libsbsms/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libsbsms-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE=""
