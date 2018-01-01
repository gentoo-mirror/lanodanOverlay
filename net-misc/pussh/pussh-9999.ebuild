# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Parallel SSH, batch and command line oriented"
HOMEPAGE="https://github.com/bearstech/pussh"
SRC_URI=""
EGIT_REPO_URI="https://github.com/bearstech/pussh.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/ssh"
RDEPEND="${DEPEND}"
