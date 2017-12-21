# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit check-reqs cmake-utils eutils flag-o-matic python-any-r1 ruby-single toolchain-funcs versionator

MY_P="qtwebkit-5.212.0-alpha2" # FIXME: ${PV}
DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://github.com/annulen/webkit"
SRC_URI="https://github.com/annulen/webkit/releases/download/${MY_P}/${MY_P}.tar.xz"
QV="5.2" # Minimum Qt version

SLOT=5

LICENSE="LGPL-2+ BSD"
KEYWORDS="~amd64 ~x86"

IUSE="+geolocation +gstreamer +jit +hyphen multimedia nsplugin orientation opengl +printsupport qml +webp X"

REQUIRED_USE="
	nsplugin? ( X )
	qml? ( opengl )
	?? ( gstreamer multimedia )
"

# Dependencies found at Source/cmake/OptionsQt.cmake
RDEPEND="
	dev-db/sqlite:3=
	>=dev-libs/icu-3.8.1-r1:=
	>=dev-libs/libxml2-2.8:2
	>=dev-libs/libxslt-1.1.7
	>=media-libs/libpng-1.4:0=
	media-libs/libwebp:=
	virtual/jpeg:0=
	>=dev-qt/qtcore-${QV}
	>=dev-qt/qtgui-${QV}
	>=dev-qt/qtnetwork-${QV}
	>=dev-qt/qtwidgets-${QV}

	geolocation? ( >=dev-qt/qtpositioning-${QV} )
	gstreamer? (
		>=dev-libs/glib-2.36:2
		>=media-libs/gstreamer-1.2:1.0
		>=media-libs/gst-plugins-base-1.2:1.0
		>=media-libs/gst-plugins-bad-1.6.0:1.0 )
	hyphen? ( dev-libs/hyphen )
	multimedia? ( >=dev-qt/qtmultimedia-${QV}[widgets] )
	opengl? ( >=dev-qt/qtopengl-${QV} )
	orientation? ( >=dev-qt/qtsensors-${QV} )
	printsupport? ( >=dev-qt/qtprintsupport-${QV} )
	qml? (
		>=dev-qt/qtdeclarative-${QV}
		>=dev-qt/qtwebchannel-${QV}[qml] )
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXrender )
"

# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=dev-lang/perl-5.10
	>=dev-util/gperf-3.0.1
	>=sys-devel/bison-2.4.3
	>=sys-devel/flex-2.5.34
	|| ( >=sys-devel/gcc-4.9 >=sys-devel/clang-3.3 )
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="1G" # Debug build requires much more see bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# older glibc needs this for INTPTR_MAX, bug #533976
	if has_version "<sys-libs/glibc-2.18" ; then
		append-cppflags "-D__STDC_LIMIT_MACROS"
	fi

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	local ruby_interpreter=""

	if has_version "virtual/rubygems[ruby_targets_ruby23]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby23)"
	elif has_version "virtual/rubygems[ruby_targets_ruby22]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby22)"
	elif has_version "virtual/rubygems[ruby_targets_ruby21]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby21)"
	else
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby20)"
	fi

	local mycmakeargs=(
		-DENABLE_API_TESTS=OFF
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DENABLE_JIT=$(usex jit)
		-DENABLE_NETSCAPE_PLUGIN_API=$(usex nsplugin)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_WEBKIT2=$(usex qml)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DENABLE_X11_TARGET=$(usex X)
		-DCMAKE_BUILD_TYPE=Release
		-DPORT=Qt
		${ruby_interpreter}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
