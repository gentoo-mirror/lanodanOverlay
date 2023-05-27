# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="kqueue(2) compatibility library"
HOMEPAGE="https://github.com/mheily/libkqueue"
SRC_URI="https://github.com/mheily/libkqueue/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC BSD-2"
SLOT="0/0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/libkqueue-2.5.0-soversion.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}
