# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core https://github.com/dotnet/core-sdk"
LICENSE="MIT"
SRC_URI="https://github.com/dotnet/core-sdk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
#IUSE=""

S="${WORKDIR}/core-sdk-${PV}"

#DEPEND=""
#RDEPEND="${DEPEND}"

src_compile() {
	OFFLINE=true ./build.sh || die
}
