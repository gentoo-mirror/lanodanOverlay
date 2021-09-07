# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Portable library for reading/writing Standard MIDI Files"
HOMEPAGE="https://github.com/tenacityteam/portsmf"
SRC_URI="https://github.com/tenacityteam/portsmf/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="examples test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}/${P}-ctest.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_APPS=$(usex examples)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
