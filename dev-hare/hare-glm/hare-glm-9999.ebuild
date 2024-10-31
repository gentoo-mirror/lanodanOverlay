# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="OpenGL-compatible linear algebra library for Hare"
HOMEPAGE="https://sr.ht/~vladh/hare-glm"
EGIT_REPO_URI="https://git.sr.ht/~vladh/hare-glm"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-lang/hare"

src_install() {
	# No Makefile present
	insinto "${EROOT}/usr/src/hare/third-party/"
	doins -r glm
}
