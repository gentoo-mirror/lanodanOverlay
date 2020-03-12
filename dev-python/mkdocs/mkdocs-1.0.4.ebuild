# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 )

inherit distutils-r1

distutils_enable_tests nose

DESCRIPTION="Project documentation with Markdown."
HOMEPAGE="https://www.mkdocs.org"
SRC_URI="https://github.com/mkdocs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/livereload-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-bootstrap-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-bootswatch-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=www-servers/tornado-5.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
