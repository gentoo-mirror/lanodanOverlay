# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Stub and/or lightweight replacements of the GNU gettext suite"
HOMEPAGE="https://github.com/sabotage-linux/gettext-tiny"
SRC_URI="https://github.com/sabotage-linux/gettext-tiny/archive/refs/tags/v${PV}.tar.gz -> gettext-tiny-${PV}.tar.gz"
S="${WORKDIR}/gettext-tiny-${PV}/"

LICENSE="MIT"
SLOT="tiny"
KEYWORDS="~amd64"
IUSE="shim"

RDEPEND="!sys-devel/gettext:0"

PATCHES=(
	"${FILESDIR}"/gettext-0.3.2-respect-CFLAGS.patch
	"${FILESDIR}"/gettext-0.3.2-xgettext-version-output.patch
	"${FILESDIR}"/gettext-0.3.2-autopoint-parenthesis.patch
	"${FILESDIR}"/gettext-0.3.2-autopoint_serial.patch
	"${FILESDIR}"/gettext-0.3.2-autopoint_mkdir.patch
)

DOCS=( README.md docs )

src_prepare() {
	default

	# Needs to be set early, otherwise scripts like autopoint have a wrong prefix value
	sed -i "s;^prefix=.*;prefix=${EPREFIX}/usr;" Makefile || die

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export AR RANLIB CC

	emake
}

multilib_src_install() {
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

	emake LIBINTL="${libintl_type}" DESTDIR="${D}" libdir="${EPREFIX}/usr/$(get_libdir)" install
}
