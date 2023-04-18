# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="tiny readline-alike with some batteries included"
HOMEPAGE="https://git.d2evs.net/~ecs/madeline/"
EGIT_REPO_URI="https://git.d2evs.net/~ecs/madeline/"
LICENSE="WTFPL-2"
SLOT="0"

DEPEND="dev-lang/hare"
RDEPEND="${DEPEND}"

DOCS=( README example.ha )

src_install() {
	einstalldocs
	# No Makefile present
	insinto "${EROOT}/usr/src/hare/third-party/"
	doins -r graph made
}
