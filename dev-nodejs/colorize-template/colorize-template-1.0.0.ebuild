# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs

DESCRIPTION="Tagged template literal for ANSI colors"
HOMEPAGE="https://github.com/usmanyunusov/colorize-template"
SRC_URI="https://github.com/usmanyunusov/colorize-template/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-nodejs/picocolors )"
