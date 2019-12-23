# Copyright 1999-2017 Gentoo Foundation
# Copyright 2018-2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ReFirmLabs/binwalk.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ReFirmLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool for identifying files embedded inside firmware images"
HOMEPAGE="https://github.com/ReFirmLabs/binwalk"

LICENSE="MIT"
SLOT="0"
IUSE="graph jffs2 squashfs"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/backports-lzma[${PYTHON_USEDEP}]' python2_7)
	graph? ( dev-python/pyqtgraph[opengl,${PYTHON_USEDEP}] )
	squashfs? (
		sys-fs/squashfs-tools:0
		sys-fs/sasquatch
	)
	jffs2? ( app-arch/jefferson )
	dev-libs/capstone[python]
	sys-fs/mtd-utils
	app-arch/arj
	app-arch/p7zip
	app-arch/cabextract
	sys-fs/cramfs
"

PATCHES=( "${FILESDIR}"/0001-Added-check-for-backports.lzma-when-importing-lzma-m.patch )

python_install_all() {
	local DOCS=( API.md README.md )
	distutils-r1_python_install_all
}
