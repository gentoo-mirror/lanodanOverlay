# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_XPINAME="${P}-firefox"

DESCRIPTION="Point and click matrix to filter net requests according to source, destination and type"
HOMEPAGE="https://github.com/gorhill/uMatrix"
SRC_URI="https://github.com/gorhill/uMatrix/releases/download/${PV}/uMatrix.firefox.xpi -> ${MY_XPINAME}.xpi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${MY_XPINAME}.xpi" . || die
}

src_install() {
	# See https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Distribution_options/Sideloading_add-ons#Installation_using_the_standard_extension_folders
	insinto "/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/"
	# Use the extension id found in the manifest.json for the filename and add .xpi
	newins "${MY_XPINAME}.xpi" "uMatrix@raymondhill.net.xpi"
}
