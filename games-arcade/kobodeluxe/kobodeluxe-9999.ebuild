# Copyright 2024 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="An SDL port of xkobo, a addictive space shoot-em-up"
HOMEPAGE="http://www.olofson.net/kobodl/ https://github.com/olofson/kobodeluxe/"
EGIT_REPO_URI="https://github.com/olofson/kobodeluxe"
SLOT="0"

DEPEND="media-libs/libsdl"

# https://github.com/olofson/kobodeluxe/pull/8
PATCHES=(
	"${FILESDIR}/CMake-Fix-desktop-icon-installation.patch"
)
