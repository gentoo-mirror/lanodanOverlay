# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Stub and/or lightweight replacements of the GNU gettext suite"
HOMEPAGE="https://github.com/sabotage-linux/gettext-tiny"
SRC_URI="https://github.com/sabotage-linux/gettext-tiny/archive/refs/tags/v${PV}.tar.gz -> gettext-tiny-${PV}.tar.gz"
S="${WORKDIR}/gettext-tiny-${PV}/"

LICENSE="BSD-1"
SLOT="tiny"
KEYWORDS="~amd64"
IUSE="shim"

RDEPEND="!sys-devel/gettext:0"

PATCHES=(
	"${FILESDIR}"/${P}-respect-CFLAGS.patch
	"${FILESDIR}"/${P}-xgettext-version-output.patch
)

DOCS=( README.md docs )

src_compile() {
	tc-export AR RANLIB CC

	emake
}

src_install() {
	local libintl_type

	if use shim ; then
		if use elibc_musl ; then
			libintl_type=MUSL
		else
			libintl_type=NOOP
		fi
	else
		# If they don't want the shim (e.g. glibc users who have their own libintl),
		# don't install a libintl and just install the binaries.
		libintl_type=NONE
	fi

	emake LIBINTL="${libintl_type}" DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
