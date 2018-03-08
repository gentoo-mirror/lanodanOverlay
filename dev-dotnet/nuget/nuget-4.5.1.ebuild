# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Nuget - .NET Package Manager"
HOMEPAGE="https://www.nuget.org/"
SRC_URI="https://dist.nuget.org/win-x86-commandline/v${PV}/nuget.exe"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_compile() { :; }

src_install() {
	doexe "${FILESDIR}/nuget"
	insinto "/usr/lib/${PN}"
	doins "${DISTDIR}/nuget.exe"
}
