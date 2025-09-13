# Copyright 2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="gzsig(1) from MirBSD"
HOMEPAGE="http://www.mirbsd.org/htman/i386/man1/gzsig.htm http://www.mirbsd.org/cvs.cgi/src/usr.bin/gzsig/"
SRC_URI="https://mbsd.evolvis.org/MirOS/dist/mir/gzsig/${P}.tgz"
S="${WORKDIR}/${PN}"
LICENSE="BSD ISC MirOS"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"
BDEPEND="dev-build/bmake"

PATCHES=(
	"${FILESDIR}/gzsig-20060130-gzsig.c-remove-__dead-for-now.patch"
	"${FILESDIR}/gzsig-20060130-pemrsa-move-__RCSID-into-an-header-comment.patch"
	"${FILESDIR}/gzsig-20060130-x509.c-Update-for-OpenSSL-3.x.patch"
	"${FILESDIR}/gzsig-20060130-Drop-usage-of-ssh.c-and-ssh2.c-for-now.patch"
)

src_configure() {
	export MANTARGET=man
}

src_compile() {
	bmake || die
}

src_install() {
	einstalldocs
	bmake DESTDIR="${D}" install || die
}
