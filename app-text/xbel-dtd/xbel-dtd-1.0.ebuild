# Copyright 2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DTD_FILE="xbel-${PV}.dtd"
DTD_DIR="/usr/share/xml/xbel/"

DESCRIPTION="XML Bookmark Exchange Language (XBEL), DTD"
HOMEPAGE="https://pyxml.sourceforge.net/topics/xbel/"
SRC_URI="https://pyxml.sourceforge.net/topics/dtds/${DTD_FILE}"
S="${WORKDIR}"

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

RDEPEND=">=dev-libs/libxml2-2.4.19"

src_unpack() { :; }

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto "${DTD_DIR}"
	doins "${DISTDIR}/${DTD_FILE}"
}

pkg_postinst() {
	einfo "Installing catalog..."

	# Install regular DOCTYPE catalog entry
	xmlcatalog --noout --add "public" \
		"+//IDN python.org//DTD XML Bookmark Exchange Language 1.0//EN//XML" \
		"${EROOT}${DTD_DIR}${DTD_FILE}" \
		"${EROOT}/etc/xml/catalog"

	# Install catalog entry for calls like: xmllint --dtdvalid URL ...
	xmlcatalog --noout --add "system" \
		"${SRC_URI}" \
		"${EROOT}${DTD_DIR}${DTD_FILE}" \
		"${EROOT}/etc/xml/catalog"
}

pkg_postrm() {
	# Remove all sk-dtd from the cache
	einfo "Cleaning catalog..."

	xmlcatalog --noout --del \
		"${EROOT}${DTD_DIR}${DTD_FILE}" \
		"${EROOT}/etc/xml/catalog"
}
