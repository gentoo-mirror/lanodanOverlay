# Copyright 2018 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build git-r3

DESCRIPTION="An experiment in scalable routing as an encrypted IPv6 overlay network"
HOMEPAGE="https://yggdrasil-network.github.io/"
EGIT_REPO_URI="git://github.com/yggdrasil-network/yggdrasil-go.git"
SLOT="0"
LICENSE="LGPL-3_linking-exception"

EGO_PN="."
