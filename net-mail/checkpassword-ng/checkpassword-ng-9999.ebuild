# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Uniform password checking interface for applications"
HOMEPAGE="https://hacktivis.me/git/checkpassword-ng/"
EGIT_REPO_URI="https://hacktivis.me/git/checkpassword-ng.git"
EGIT_MIN_CLONE_TYPE="single+tags"
LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="suid"

RDEPEND="virtual/libcrypt:="
DEPEND="${RDEPEND}"
