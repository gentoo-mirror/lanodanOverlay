# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="fork of the GYP (Generate Your Projects) build system for use in the Node.js projects"
HOMEPAGE="https://github.com/nodejs/gyp-next"
SRC_URI="https://github.com/nodejs/gyp-next/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

RDEPEND="!dev-util/gyp"

distutils_enable_tests pytest
