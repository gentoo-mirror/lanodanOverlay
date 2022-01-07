# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 git-r3

DESCRIPTION="Standalone Steam Controller Driver"
HOMEPAGE="https://github.com/ynsta/steamcontroller"
EGIT_REPO_URI="https://github.com/ynsta/steamcontroller"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+udev"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/libusb1[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	udev? ( games-util/game-device-udev-rules )
"
