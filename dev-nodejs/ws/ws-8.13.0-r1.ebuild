# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs optfeature

DESCRIPTION="Simple to use, blazing fast and thoroughly tested WebSocket client and server for Node.js"
HOMEPAGE="https://github.com/websockets/ws"
SRC_URI="https://github.com/websockets/ws/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

DOCS=( SECURITY.md README.md doc examples )

pkg_postinst() {
	if has_version '<dev-lang/nodejs-18.14.0'; then
		optfeature "(<nodejs-18.14.0) efficiently check if a message contains valid UTF-8" \
			dev-nodejs/utf-8-validate
	fi

	optfeature "efficiently perform operations such as masking and unmasking" \
		dev-nodejs/bufferutil
}
