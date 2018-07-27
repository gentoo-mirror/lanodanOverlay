# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-base prefix toolchain-funcs

DESCRIPTION="GNUstep Makefile Package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="libobjc2 native-exceptions"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75
	libobjc2? ( gnustep-base/libobjc2
		sys-devel/clang )
	!libobjc2? ( !!gnustep-base/libobjc2
		|| (
			>=sys-devel/gcc-3.3[objc]
			sys-devel/clang
		) )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Multilib-strict
	sed -e "s#/lib#/$(get_libdir)#" -i FilesystemLayouts/fhs-system || die "sed failed"
	cp "${FILESDIR}"/gnustep-5.{csh,sh} "${T}"/
	eprefixify "${T}"/gnustep-5.{csh,sh}

	default
}

src_configure() {
	#--enable-objc-nonfragile-abi: only working in clang for now
	econf \
		INSTALL="${EPREFIX}"/usr/bin/install \
		--with-layout=fhs-system \
		--with-config-file="${EPREFIX}"/etc/GNUstep/GNUstep.conf \
		--with-objc-lib-flag=-l:${libobjc_version} \
		$(use_enable libobjc2 objc-nonfragile-abi) \
		$(use_enable native-exceptions native-objc-exceptions)
}

src_compile() {
	emake
	if use doc ; then
		emake -C Documentation
	fi
}

src_install() {
	# Get GNUSTEP_* variables
	. ./GNUstep.conf

	local make_eval
	use debug || make_eval="${make_eval} debug=no"
	make_eval="${make_eval} verbose=yes"

	emake ${make_eval} DESTDIR="${D}" install

	# Copy the documentation
	if use doc ; then
		emake -C Documentation ${make_eval} DESTDIR="${D}" install
	fi

	dodoc FAQ README RELEASENOTES

	exeinto /etc/profile.d
	doexe "${T}"/gnustep-?.sh
	doexe "${T}"/gnustep-?.csh
}

pkg_postinst() {
	# Warn about new layout if old GNUstep directory is still here
	if [ -e /usr/GNUstep/System ]; then
		ewarn "Old layout directory detected (/usr/GNUstep/System)"
		ewarn "Gentoo has switched to FHS layout for GNUstep packages"
		ewarn "You must first update the configuration files from this package,"
		ewarn "then remerge all packages still installed with the old layout"
		ewarn "You can use gnustep-base/gnustep-updater for this task"
	fi
}
