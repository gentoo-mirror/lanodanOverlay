# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit flag-o-matic gstreamer-meson virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"

# TODO: egl and gtk IUSE only for transition
IUSE="X bzip2 +egl gles2 gtk +introspection +opengl +orc vnc wayland" # Keep default IUSE mirrored with gst-plugins-base where relevant

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# We mirror opengl/gles2 from -base to ensure no automagic openglmixers plugin (with "opengl?" it'd still get built with USE=-opengl here)
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl?,introspection?,gles2=,opengl=]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.4
	)

	gtk? ( >=media-plugins/gst-plugins-gtk-${PV}:${SLOT}[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
"

RESTRICT="test"

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	local emesonargs=(
		-Dshm=enabled
		-Dipcpipeline=enabled
		$(meson_feature orc)
		$(meson_feature vnc librfb)
		$(meson_feature wayland)
	)

	if use opengl || use gles2; then
		myconf+=( -Dgl=enabled )
	else
		myconf+=( -Dgl=disabled )
	fi

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	unset DISPLAY
	# Tests are slower than upstream expects
	CK_DEFAULT_TIMEOUT=300 virtx eninja check
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
