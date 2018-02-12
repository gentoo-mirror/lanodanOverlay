# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="zx2c4 pass manager extension for Firefox"
HOMEPAGE="https://github.com/passff/passff"
SRC_URI="
	extension_host? (
		https://github.com/passff/passff/releases/download/${PV}/passff.json -> ${P}.json
		https://github.com/passff/passff/releases/download/${PV}/passff.py -> ${P}.py
	)
	extension_xpi? (
		https://github.com/passff/passff/releases/download/${PV}/passff.xpi -> ${P}.xpi
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extension_xpi +extension_host"

DEPEND=""
RDEPEND="
	${DEPEND}
	>=dev-lang/python-3.4.0:*
"

TARGET_DIR="${EROOT}usr/lib/mozilla/native-messaging-hosts"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	for i in ${A}; do
		cp ${DISTDIR}/$i "${WORKDIR}/${P}" || die "Failed copying ${i} to workdir"
	done
}

src_compile() {
	if use extension_host; then
		sed -i "s|PLACEHOLDER|${TARGET_DIR}/${PN}.py|" "${P}.json"
	fi
}

src_install() {
	if use extension_host; then
		insinto "${TARGET_DIR}"
		newins "${P}.json" passff.json
		newins "${P}.py" passff.py
		chmod +x "${D}${TARGET_DIR}/passff.py"
	fi
}
