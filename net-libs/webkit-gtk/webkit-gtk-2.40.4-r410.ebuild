# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{8..11} )
USE_RUBY="ruby27 ruby30 ruby31"

inherit check-reqs flag-o-matic gnome2 python-any-r1 ruby-single toolchain-funcs cmake

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.webkitgtk.org"
SRC_URI="https://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="4.1/0" # soname version of libwebkit2gtk-4.1
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

IUSE="aqua +avif debug doc +egl examples gamepad +geolocation gles2-only gnome-keyring +gstreamer +introspection +jpeg2k jpegxl +jumbo-build lcms +seccomp spell systemd test wayland webrtc +X"

# gstreamer with opengl/gles2 needs egl
REQUIRED_USE="
	doc? ( introspection )
	gles2-only? ( egl )
	gstreamer? ( egl )
	wayland? ( egl )
	webrtc? ( gstreamer )
	|| ( aqua wayland X )
"

# Tests fail to link for inexplicable reasons
# https://bugs.webkit.org/show_bug.cgi?id=148210
RESTRICT="test"

# Dependencies found at Source/cmake/OptionsGTK.cmake
# Various compile-time optionals for gtk+-3.22.0 - ensure it
# >=gst-plugins-opus-1.14.4-r1 for opusparse (required by MSE)
RDEPEND="
	>=x11-libs/cairo-1.16.0:=[X?]
	>=media-libs/fontconfig-2.13.0:1.0
	>=media-libs/freetype-2.9.0:2
	>=dev-libs/libgcrypt-1.7.0:0=
	>=x11-libs/gtk+-3.22.0:3[aqua?,introspection?,wayland?,X?]
	>=media-libs/harfbuzz-1.4.2:=[icu(+)]
	>=dev-libs/icu-61.2:=
	media-libs/libjpeg-turbo:0=
	>=net-libs/libsoup-2.99.9:3.0[introspection?]
	>=dev-libs/libxml2-2.8.0:2
	>=media-libs/libpng-1.4:0=
	dev-db/sqlite:3=
	sys-libs/zlib:0
	>=dev-libs/atk-2.16.0
	media-libs/libwebp:=

	>=dev-libs/glib-2.67.1:2
	>=dev-libs/libxslt-1.1.7
	media-libs/woff2
	gnome-keyring? ( app-crypt/libsecret )
	introspection? ( >=dev-libs/gobject-introspection-1.59.1:= )
	dev-libs/libtasn1:=
	spell? ( >=app-text/enchant-0.22:2 )
	gstreamer? (
		>=media-libs/gstreamer-1.14:1.0
		>=media-libs/gst-plugins-base-1.14:1.0[egl?,X?]
		>=media-plugins/gst-plugins-opus-1.14.4-r1:1.0
		>=media-libs/gst-plugins-bad-1.14:1.0[X?]
		gles2-only? ( media-libs/gst-plugins-base:1.0[gles2] )
		!gles2-only? ( media-libs/gst-plugins-base:1.0[opengl] )
	)
	webrtc? (
		media-plugins/gst-plugins-webrtc:1.0
		>=dev-libs/openssl-3:=
	)

	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender
		x11-libs/libXt )

	dev-libs/hyphen
	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2= )
	jpegxl? ( media-libs/libjxl )
	avif? ( >=media-libs/libavif-0.9.0:= )
	lcms? ( media-libs/lcms:2 )

	egl? ( media-libs/mesa[egl(+)] )
	gles2-only? ( media-libs/mesa[gles2] )
	!gles2-only? ( virtual/opengl )
	wayland? (
		dev-libs/wayland
		>=dev-libs/wayland-protocols-1.12
		>=gui-libs/libwpe-1.5.0:1.0
		>=gui-libs/wpebackend-fdo-1.7.0:1.0
	)
	seccomp? (
		>=sys-apps/bubblewrap-0.3.1
		sys-libs/libseccomp
		sys-apps/xdg-dbus-proxy
	)
	systemd? ( sys-apps/systemd:= )
	gamepad? ( >=dev-libs/libmanette-0.2.4 )
"

DEPEND="${RDEPEND}"

# Need real bison, not yacc
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	dev-util/glib-utils
	>=dev-util/gperf-3.0.1
	>=sys-devel/bison-2.4.3
	|| ( >=sys-devel/gcc-7.3 >=sys-devel/clang-5 )
	sys-devel/gettext
	virtual/pkgconfig

	>=dev-lang/perl-5.10
	virtual/perl-Data-Dumper
	virtual/perl-Carp
	virtual/perl-JSON-PP

	doc? ( dev-util/gi-docgen )
	geolocation? ( dev-util/gdbus-codegen )
	>=dev-util/cmake-3.10
	dev-util/unifdef
"
RDEPEND="${RDEPEND}
	geolocation? ( >=app-misc/geoclue-2.1.5:2.0 )
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi

		if ! test-flag-CXX -std=c++17 ; then
			die "You need at least GCC 7.3.x or Clang >= 5 for C++17-specific compiler flags"
		fi
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# WebkitGTK doesn't likes -D_FORTIFY_SOURCE=2
	strip-flags
	filter-flags "-D_FORTIFY_SOURCE=*"

	# It does not compile on alpha without this in LDFLAGS
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648761
	use alpha && append-ldflags "-Wl,--no-relax"

	# ld segfaults on ia64 with LDFLAGS --as-needed, bug #555504
	use ia64 && append-ldflags "-Wl,--no-as-needed"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	# --no-keep-memory doesn't work on ia64, bug #502492
	if ! use ia64; then
		append-ldflags $(test-flags-CCLD "-Wl,--no-keep-memory")
	fi

	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY}; do
		if has_version -b "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z $ruby_interpreter ]] && die "No suitable ruby interpreter found"

	# TODO: Check Web Audio support
	# should somehow let user select between them?

	local mycmakeargs=(
		${ruby_interpreter}
		$(cmake_use_find_package gles2-only OpenGLES2)
		$(cmake_use_find_package egl EGL)
		$(cmake_use_find_package !gles2-only OpenGL)
		-DBWRAP_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/bwrap # If bubblewrap[suid] then portage makes it go-r and cmake find_program fails with that
		-DDBUS_PROXY_EXECUTABLE:FILEPATH="${EPREFIX}"/usr/bin/xdg-dbus-proxy
		-DPORT=GTK

		# Source/cmake/WebKitFeatures.cmake
		-DENABLE_API_TESTS=$(usex test)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex seccomp)
		-DENABLE_GAMEPAD=$(usex gamepad)
		-DENABLE_GEOLOCATION=$(usex geolocation) # Runtime optional (talks over dbus service)
		-DENABLE_MINIBROWSER=$(usex examples)
		-DSHOULD_INSTALL_JS_SHELL=$(usex examples)
		-DENABLE_SPELLCHECK=$(usex spell)
		-DENABLE_UNIFIED_BUILDS=$(usex jumbo-build)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEBGL=ON
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEBDRIVER=OFF
		# -DENABLE_TOUCH_EVENTS=OFF
		# -DENABLE_DRAG_SUPPORT=OFF

		# Source/cmake/OptionsGTK.cmake
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_DOCUMENTATION=$(usex doc)
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DENABLE_JOURNALD_LOG=$(usex systemd)
		-DENABLE_PDFJS=OFF # gentoo has www-plugins/pdfjs
		-DENABLE_QUARTZ_TARGET=$(usex aqua)
		-DENABLE_WAYLAND_TARGET=$(usex wayland)
		-DENABLE_WEB_RTC=$(usex webrtc)
		-DENABLE_MEDIA_STREAM=$(usex webrtc)
		-DENABLE_X11_TARGET=$(usex X)
		#-DUSE_ANGLE_WEBGL=OFF
		-DUSE_AVIF=$(usex avif)
		-DUSE_GTK4=OFF
		-DUSE_JPEGXL=$(usex jpegxl)
		-DUSE_LCMS=$(usex lcms)
		-DUSE_LIBHYPHEN=ON
		-DUSE_LIBSECRET=$(usex gnome-keyring)
		-DUSE_OPENGL_OR_ES=ON
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_SOUP2=OFF
		-DUSE_WOFF2=ON
		-DUSE_WPE_RENDERER=$(usex wayland) # WPE renderer is used to implement accelerated compositing under wayland
	)

	# https://bugs.gentoo.org/761238
	append-cppflags -DNDEBUG

	cmake_src_configure
}