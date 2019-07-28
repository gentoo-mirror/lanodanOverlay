# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
GNOME2_LA_PUNT="yes"

inherit bash-completion-r1 epunt-cxx flag-o-matic gnome-meson libtool linux-info \
	multilib multilib-minimal pax-utils python-any-r1 toolchain-funcs virtualx

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="https://www.gtk.org/"
LICENSE="LGPL-2.1+"
SLOT="2"
IUSE="dbus debug fam gtk-doc kernel_linux +mime selinux static-libs systemtap test utils xattr"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

# Added util-linux multilib dependency to have libmount support (which
# is always turned on on linux systems, unless explicitly disabled, but
# this ebuild does not do that anyway) (bug #599586)

RDEPEND="
	!<dev-util/gdbus-codegen-${PV}
	>=dev-libs/libpcre-8.31:3[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	kernel_linux? ( >=sys-apps/util-linux-2.23[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
	utils? (
		${PYTHON_DEPS}
		>=dev-util/gdbus-codegen-${PV}
		virtual/libelf:0=
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/libxslt-1.0
	>=sys-devel/gettext-0.11
	gtk-doc? ( >=dev-util/gtk-doc-1.20 )
	systemtap? ( >=dev-util/systemtap-1.3 )
	${PYTHON_DEPS}
	test? (
		sys-devel/gdb
		${PYTHON_DEPS}
		>=dev-util/gdbus-codegen-${PV}
		>=sys-apps/dbus-1.2.14 )
"
PDEPEND="!<gnome-base/gvfs-1.6.4-r990
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"
# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436
# Earlier versions of gvfs do not work with glib

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gio-querymodules$(get_exeext)
)

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INOTIFY_USER"
		if use test ; then
			CONFIG_CHECK="~IPV6"
			WARNING_IPV6="Your kernel needs IPV6 support for running some tests, skipping them."
		fi
		linux-info_pkg_setup
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	# gdbus-codegen is a separate package
	eapply "${FILESDIR}"/${PN}-2.61.1-external-codegen.patch

	# Tarball doesn't come with gtk-doc.make and we can't unconditionally depend on dev-util/gtk-doc due
	# to circular deps during bootstramp. If actually not building gtk-doc, an almost empty file will do
	# fine as well - this is also what upstream autogen.sh does if gtkdocize is not found. If gtk-doc is
	# installed, eautoreconf will call gtkdocize, which overwrites the empty gtk-doc.make with a full copy.
	cat > gtk-doc.make << EOF
EXTRA_DIST =
CLEANFILES =
EOF

	gnome-meson_src_prepare
	epunt_cxx
}

multilib_src_configure() {
	# These configure tests don't work when cross-compiling.
	if tc-is-cross-compiler ; then
		# https://bugzilla.gnome.org/show_bug.cgi?id=756473
		case ${CHOST} in
		hppa*|metag*) export glib_cv_stack_grows=yes ;;
		*)            export glib_cv_stack_grows=no ;;
		esac
		# https://bugzilla.gnome.org/show_bug.cgi?id=756474
		export glib_cv_uscore=no
		# https://bugzilla.gnome.org/show_bug.cgi?id=756475
		export ac_cv_func_posix_get{pwuid,grgid}_r=yes
	fi

	local myconf

	use static-libs && myconf="-Ddefault_library='static'"
	use debug && myconf="$myconf -Dbuildtype='debug'"

	gnome-meson_src_configure \
		${myconf} \
		-Denable-libmount=$(usex kernel_linux yes no) \
		$(meson_use systemtap enable-dtrace) \
		$(meson_use systemtap enable-systemtap) \
		-Dwith-pcre=system \
		-Dwith-docs=no \
		-Dwith-man=yes

	if multilib_is_native_abi; then
		local d
		for d in glib gio gobject; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi
}

multilib_src_compile() {
	gnome-meson_src_compile
}

multilib_src_test() {
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export G_DBUS_COOKIE_SHA1_KEYRING_DIR="${T}/temp"
	export LC_TIME=C # bug #411967
	unset GSETTINGS_BACKEND # bug #596380
	python_setup

	# Related test is a bit nitpicking
	mkdir "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"
	chmod 0700 "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"

	# Hardened: gdb needs this, bug #338891
	if host-is-pax ; then
		pax-mark -mr "${BUILD_DIR}"/tests/.libs/assert-msg-test \
			|| die "Hardened adjustment failed"
	fi

	# Need X for dbus-launch session X11 initialization
	virtx meson_src_test
}

multilib_src_install() {
	chmod +x glib-gettextize || die
	gnome-meson_src_install completiondir="$(get_bashcompdir)"
	keepdir /usr/$(get_libdir)/gio/modules
}

multilib_src_install_all() {
	einstalldocs

	if use utils; then
		python_replicate_script "${ED}"/usr/bin/gtester-report
	else
		rm "${ED}usr/bin/gtester-report"
		rm "${ED}usr/share/man/man1/gtester-report.1"
	fi

	# Do not install charset.alias even if generated, leave it to libiconv
	rm -f "${ED}/usr/lib/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"
}

pkg_preinst() {
	gnome-meson_pkg_preinst

	# Make gschemas.compiled belong to glib alone
	local cache="usr/share/glib-2.0/schemas/gschemas.compiled"

	if [[ -e ${EROOT}${cache} ]]; then
		cp "${EROOT}"${cache} "${ED}"/${cache} || die
	else
		touch "${ED}"/${cache} || die
	fi

	multilib_pkg_preinst() {
		# Make giomodule.cache belong to glib alone
		local cache="usr/$(get_libdir)/gio/modules/giomodule.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}

	# Don't run the cache ownership when cross-compiling, as it would end up with an empty cache
	# file due to inability to create it and GIO might not look at any of the modules there
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_preinst
	fi
}

pkg_postinst() {
	# force (re)generation of gschemas.compiled
	GNOME2_ECLASS_GLIB_SCHEMAS="force"

	gnome-meson_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_postinst
	else
		ewarn "Updating of GIO modules cache skipped due to cross-compilation."
		ewarn "You might want to run gio-querymodules manually on the target for"
		ewarn "your final image for performance reasons and re-run it when packages"
		ewarn "installing GIO modules get upgraded or added to the image."
	fi
}

pkg_postrm() {
	gnome-meson_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gio/modules/giomodule.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
		rm -f "${EROOT}"usr/share/glib-2.0/schemas/gschemas.compiled
	fi
}
