# Copyright 1999-2018 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="https://dev.gajim.org/gajim/python-nbxmpp/"
SRC_URI="https://dev.gajim.org/gajim/python-nbxmpp/-/archive/nbxmpp-${PV}/python-nbxmpp-nbxmpp-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${PN}-nbxmpp-${PV}"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/precis-i18n-1.0.0
	>=dev-python/pyopenssl-16.2
"
