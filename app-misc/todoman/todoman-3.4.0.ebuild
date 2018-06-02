# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=(python{3_4,3_5,3_6})

inherit distutils-r1 bash-completion-r1

DESCRIPTION="A simple CalDav-based todo manager"
HOMEPAGE="https://github.com/pimutils/todoman"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="bash-completion test repl zsh-completion"

RDEPEND=">=dev-python/click-6.0[${PYTHON_USEDEP}]
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/icalendar[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.2.1[${PYTHON_USEDEP}]
	repl? ( dev-python/click-repl[${PYTHON_USEDEP}] )"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )"

DOCS=( docs/source/contributing.rst README.rst todoman.conf.sample )

src_install() {
	distutils-r1_src_install

	dobashcomp contrib/completion/bash/_todo

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/completion/zsh/_todo
	fi
}
