# Copyright 2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tiny signify replacement"
HOMEPAGE="https://git.openwrt.org/?p=project/usign.git"

if [[ "${PV}" = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://git.openwrt.org/?p=project/usign.git"
else
	EGIT_COMMIT="f1f65026a94137c91b5466b149ef3ea3f20091e9"
	# 403 Forbidden
	#SRC_URI="https://git.openwrt.org/?p=project/usign.git;a=snapshot;h=${EGIT_COMMIT};sf=tgz -> ${PN}-${EGIT_COMMIT}.tar.gz"
	SRC_URI="https://github.com/openwrt/usign/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

	KEYWORDS="~amd64 ~arm64 ~arm"
fi

LICENSE="public-domain ISC"
SLOT="0"
IUSE=""

src_prepare() {
	cmake_src_prepare

	sed -i -e '/ADD_DEFINITIONS/s;-O2;;' CMakeLists.txt || die "Failed removing -O2 flag"
}
