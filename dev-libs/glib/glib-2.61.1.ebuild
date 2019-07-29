# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit bash-completion-r1 flag-o-matic gnome.org gnome2-utils linux-info meson multilib multilib-minimal python-any-r1 toolchain-funcs xdg

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="https://www.gtk.org/"
LICENSE="LGPL-2.1+"
SLOT="2"
IUSE="dbus debug fam gtk-doc kernel_linux +mime selinux static-libs systemtap test utils xattr"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/libpcre-8.31:3[${MULTILIB_USEDEP},static-libs?]
	!<dev-util/gdbus-codegen-${PV}
	>=dev-util/gdbus-codegen-${PV}
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	virtual/libelf:0=
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	kernel_linux? ( >=sys-apps/util-linux-2.23[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/libxslt-1.0
	>=sys-devel/gettext-0.11
	gtk-doc? ( >=dev-util/gtk-doc-1.20 )
	systemtap? ( >=dev-util/systemtap-1.3 )
	${PYTHON_DEPS}
	test? ( >=sys-apps/dbus-1.2.14 )
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
PDEPEND="
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"
# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436

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
	if ! use test; then
		# Don't build tests, also prevents extra deps, bug #512022
		sed -i -e '/subdir.*tests/d' {.,gio,glib}/meson.build || die
	fi

	# Don't build fuzzing binaries - not used
	sed -i -e '/subdir.*fuzzing/d' meson.build || die

	# gdbus-codegen is a separate package
	sed -i -e 's/install.*true/install : false/g' gio/gdbus-2.0/codegen/meson.build || die
	# Older than meson-0.50 doesn't know about install kwarg for configure_file; for that we need to remove the install_dir kwarg.
	# Upstream will remove the install kwarg in a future version to require only meson-0.49.2 or newer, at which point the
	# install_dir removal only should be kept.
	sed -i -e '/install_dir/d' gio/gdbus-2.0/codegen/meson.build || die

	# Same kind of meson-0.50 issue with some installed-tests files; will likely be fixed upstream soon
	sed -i -e '/install_dir/d' gio/tests/meson.build || die

	cat > "${T}/glib-test-ld-wrapper" <<-EOF
		#!/usr/bin/env sh
		exec \${LD:-ld} "\$@"
	EOF
	chmod a+x "${T}/glib-test-ld-wrapper" || die
	sed -i -e "s|'ld'|'${T}/glib-test-ld-wrapper'|g" gio/tests/meson.build || die

	xdg_src_prepare
	gnome2_environment_reset
	# TODO: python_name sedding for correct python shebang? Might be relevant mainly for glib-utils only
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

	if multilib_is_native_abi; then
		local d
		for d in glib gio gobject; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi

	local emesonargs=(
		$(usex debug "-Dbuildtype='debug'" "")
		-Ddefault_library=$(usex static-libs both shared)
		$(meson_feature selinux)
		$(meson_use xattr)
		-Dlibmount=true # only used if host_system == 'linux'
		-Dinternal_pcre=false
		-Dman=true
		$(meson_use systemtap dtrace)
		$(meson_use systemtap)
		-Dgtk_doc=$(multilib_native_usex gtk-doc true false)
		$(meson_use fam)
		-Dinstalled_tests=false
		-Dnls=enabled
	)


	meson_src_configure

}

multilib_src_compile() {
	meson_src_compile
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

	meson_src_test --timeout-multiplier 2 --no-suite flaky
}

multilib_src_install() {
	chmod +x glib-gettextize || die
	meson_src_install completiondir="$(get_bashcompdir)"
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

	# These are installed by dev-util/glib-utils
	# TODO: With patching we might be able to get rid of the python-any deps and removals, and test depend on glib-utils instead; revisit now with meson
	rm "${ED}/usr/bin/glib-genmarshal" || die
	rm "${ED}/usr/share/man/man1/glib-genmarshal.1" || die
	rm "${ED}/usr/bin/glib-mkenums" || die
	rm "${ED}/usr/share/man/man1/glib-mkenums.1" || die
	rm "${ED}/usr/bin/gtester-report" || die
	rm "${ED}/usr/share/man/man1/gtester-report.1" || die
	# gdbus-codegen manpage installed by dev-util/gdbus-codegen
	rm "${ED}/usr/share/man/man1/gdbus-codegen.1" || die
}

pkg_preinst() {
	xdg_pkg_preinst

	# Make gschemas.compiled belong to glib alone
	local cache="/usr/share/glib-2.0/schemas/gschemas.compiled"

	if [[ -e "${EROOT}${cache}" ]]; then
		cp "${EROOT}${cache}" "${ED}${cache}" || die
	else
		touch "${ED}${cache}" || die
	fi

	multilib_pkg_preinst() {
		# Make giomodule.cache belong to glib alone
		local cache="/usr/$(get_libdir)/gio/modules/giomodule.cache"

		if [[ -e "${EROOT}${cache}" ]]; then
			cp "${EROOT}${cache}" "${ED}${cache}" || die
		else
			touch "${ED}${cache}" || die
		fi
	}

	# Don't run the cache ownership when cross-compiling, as it would end up with an empty cache
	# file due to inability to create it and GIO might not look at any of the modules there
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_preinst
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	# glib installs no schemas itself, but we force update for fresh install in case
	# something has dropped in a schemas file without direct glib dep; and for upgrades
	# in case the compiled schema format could have changed
	gnome2_schemas_update

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
	xdg_pkg_postrm
	gnome2_schemas_update

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"/usr/$(get_libdir)/gio/modules/giomodule.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
		rm -f "${EROOT}"/usr/share/glib-2.0/schemas/gschemas.compiled
	fi
}
