# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
USE_RUBY="ruby24 ruby25 ruby26"

inherit cmake-utils python-any-r1 ruby-single

DESCRIPTION="WebKit port optimized for embedded devices"
HOMEPAGE="https://wpewebkit.org/"
LICENSE="LGPL-2+ BSD"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"
SLOT="1.0" # WPE_API_VERSION
KEYWORDS="~amd64 ~arm"
IUSE="doc examples experimental jpeg2k qt +gstreamer"

RDEPEND="
	>=x11-libs/cairo-1.10.2:=
	>=media-libs/fontconfig-2.8.0:=
	>=media-libs/freetype-2.4.2:=
	>=dev-libs/glib-2.40.0:=
	>=media-libs/harfbuzz-0.9.18:=
	dev-libs/icu
	virtual/jpeg:=
	>=media-libs/libepoxy-1.4.0:=
	>=dev-libs/libgcrypt-1.6.0:=
	>=net-libs/libsoup-2.42.0:=
	>=dev-libs/libxml2-2.8.0:=
	media-libs/libpng:=
	dev-db/sqlite:=
	media-libs/libwebp:=
	net-libs/libwpe:=
	sys-libs/zlib:=

	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2= )
	qt? (
		dev-qt/qtcore:5=
		dev-qt/qtquickcontrols:5=
		dev-qt/qtgui:5=
		>=dev-libs/wpebackend-fdo-1.0:=
	)
	gstreamer? (
		>=media-libs/gstreamer-1.14:1.0
		>=media-libs/gst-plugins-base-1.14:1.0[egl]
		>=media-plugins/gst-plugins-opus-1.14.4-r1:1.0
		>=media-libs/gst-plugins-bad-1.14:1.0
	)
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}

	>=dev-lang/perl-5.10
	virtual/perl-JSON-PP

	doc? ( >=dev-util/gtk-doc-1.10 )
"

src_configure() {
	# Ruby situation is a bit complicated. See bug 513888
	local rubyimpl
	local ruby_interpreter=""
	for rubyimpl in ${USE_RUBY}; do
		if has_version "virtual/rubygems[ruby_targets_${rubyimpl}]"; then
			ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ${rubyimpl})"
		fi
	done
	# This will rarely occur. Only a couple of corner cases could lead us to
	# that failure. See bug 513888
	[[ -z $ruby_interpreter ]] && die "No suitable ruby interpreter found"

	local mycmakeargs=(
		"-DPORT=WPE"
		-DSHOULD_INSTALL_JS_SHELL=ON
		-DENABLE_EXPERIMENTAL_FEATURES=$(usex experimental)
		-DENABLE_GTKDOC=$(usex doc)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DENABLE_WPE_QT_API=$(usex qt)
		-DENABLE_MINIBROWSER=$(usex examples)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		${ruby_interpreter}
	)

	cmake-utils_src_configure
}
