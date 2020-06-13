# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="gtk"

inherit meson gnome2 multilib virtualx multilib-minimal

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="broadway colord cups cloudprint cloudproviders examples ffmpeg +gstreamer gtk-doc +introspection test vim-syntax wayland +X xinerama tracker3 vulkan profiler"
REQUIRED_USE="
	|| ( wayland X )
	xinerama? ( X )
"

KEYWORDS="~amd64"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768662#c1
RESTRICT="test"

BDEPEND="
	>=dev-util/meson-0.54.2
	dev-lang/sassc
	dev-util/gdbus-codegen
	sys-apps/diffutils
	dev-libs/libxslt
"

# gstreamer-player-1.0.pc => media-libs/gst-plugins-bad
DEPEND="
	>=dev-libs/glib-2.63.1:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.45.0[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.15.1[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14[glib,svg,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/graphene-1.9.1[${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.4[X(+)?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-protocols-1.20
		>=dev-libs/wayland-1.14.91[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	>=media-libs/harfbuzz-0.9:=
	app-text/iso-codes
	tracker3? ( >=app-misc/tracker-3.0 )
	X? (
		>=x11-libs/libXrandr-1.5[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
	vulkan? (
		media-libs/vulkan-loader
		media-libs/shaderc
	)
	cloudproviders? ( dev-libs/libcloudproviders )
	profiler? ( dev-util/sysprof-capture )

	ffmpeg? ( media-video/ffmpeg:= )

	gstreamer? ( >=media-libs/gst-plugins-bad-1.12.3 )

	cups? ( net-print/cups )
	cloudprint? (
		net-libs/rest:0.7
		dev-libs/json-glib
	)
	colord? ( >=x11-misc/colord-0.1.9 )
"

src_prepare() {
	gnome2_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use X x11-backend)
		$(meson_use wayland wayland-backend)
		$(meson_use broadway broadway-backend)

		-Dvulkan=$(usex vulkan)
		-Dxinerama=$(usex xinerama)
		$(meson_use cloudproviders)
		$(meson_use profiler)
		$(meson_use tracker3)

		-Dprint-backends=file,lpr$(usex cups ,cups '')$(usex cloudprint ,cloudprint '')
		-Dcolord=$(usex colord)
	)

	if use ffmpeg && use gstreamer; then
		emesonargs+=( -Dmedia=ffmpeg,gstreamer )
	elif use ffmpeg; then
		emesonargs+=( -Dmedia=ffmpeg )
	elif use gstreamer; then
		emesonargs+=( -Dmedia=gstreamer )
	else
		emesonargs+=( -Dmedia=none )
	fi

	meson_src_configure
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	DOCS=( NEWS CONTRIBUTING.md README.md )
	einstalldocs
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_query_immodules_gtk3 \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gtk-4.0/4.0.0/immodules.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}
