# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library to look for special directories like ~/.config and %APPDATA%"
HOMEPAGE="https://github.com/sago007/PlatformFolders"
SRC_URI="https://github.com/sago007/PlatformFolders/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
