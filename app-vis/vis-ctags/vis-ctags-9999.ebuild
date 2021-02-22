# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="vis plugin to provide basic ctags support"
HOMEPAGE="https://github.com/kupospelov/vis-ctags"
EGIT_REPO_URI="https://github.com/kupospelov/vis-ctags"
LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-util/ctags
	>=app-editors/vis-0.7[lua]
"

src_install() {
	einstalldocs
	insinto /usr/share/vis/
	doins ctags.lua
}

pkg_install() {
	einfo "Add require('ctags') to your vis configuration to enable ctags support"
}
