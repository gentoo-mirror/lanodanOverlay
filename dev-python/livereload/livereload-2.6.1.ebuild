# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 )

inherit distutils-r1

distutils_enable_tests nose

DESCRIPTION="Python LiveReload is an awesome tool for web developers"
HOMEPAGE="https://github.com/lepture/python-livereload"
SRC_URI="https://github.com/lepture/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples test"
RESTRICT="test? ( test )"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"

S="${WORKDIR}/python-${P}"

python_install_all() {
	use examples && local EXAMPLES=( example/. )

	distutils-r1_python_install_all
}
