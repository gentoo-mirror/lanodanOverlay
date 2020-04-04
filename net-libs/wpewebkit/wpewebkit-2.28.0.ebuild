# Copyright 2019-2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
USE_RUBY="ruby24 ruby25 ruby26"

inherit cmake python-any-r1 ruby-single

DESCRIPTION="WebKit port optimized for embedded devices"
HOMEPAGE="https://wpewebkit.org/"
LICENSE="LGPL-2+ BSD"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"
SLOT="1.0" # WPE_API_VERSION
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="accessibility doc examples experimental jpeg2k qt +gstreamer sandbox +webdriver +webcrypto"

RDEPEND="
	>=x11-libs/cairo-1.14.0:=
	>=media-libs/fontconfig-2.8.0:=
	>=media-libs/freetype-2.4.2:=
	>=dev-libs/glib-2.44.0:=
	>=media-libs/harfbuzz-0.9.18:=
	dev-libs/icu
	virtual/jpeg:=
	>=media-libs/libepoxy-1.4.0:=
	>=dev-libs/libgcrypt-1.6.0:=
	>=net-libs/libsoup-2.54.0:=
	>=dev-libs/libxml2-2.8.0:=
	media-libs/libpng:=
	dev-db/sqlite:=
	media-libs/libwebp:=
	gui-libs/libwpe:=
	sys-libs/zlib:=

	>=dev-libs/libxslt-1.1.7
	>=media-libs/woff2-1.0.2

	jpeg2k? ( >=media-libs/openjpeg-2.2.0:2= )
	webcrypto? (
		dev-libs/libtasn1:=
		>=dev-libs/libgcrypt-1.7.0:=
	)
	qt? (
		dev-qt/qtcore:5=
		dev-qt/qtquickcontrols:5=
		dev-qt/qtgui:5=
		dev-qt/qttest:5=
		>=gui-libs/wpebackend-fdo-1.3.0:=
	)
	gstreamer? (
		>=media-libs/gstreamer-1.14:1.0
		>=media-libs/gst-plugins-base-1.14:1.0[egl]
		>=media-plugins/gst-plugins-opus-1.14.4-r1:1.0
		>=media-libs/gst-plugins-bad-1.14:1.0
	)
	accessibility? (
		>=dev-libs/atk-2.16.0:=
		app-accessibility/at-spi2-atk:=
	)
	sandbox? ( sys-apps/bubblewrap )
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
		-DENABLE_ACCESSIBILITY=$(usex accessibility)
		-DENABLE_BUBBLEWRAP_SANDBOX=$(usex sandbox)
		-DUSE_WOFF2=ON
		-DSHOULD_INSTALL_JS_SHELL=ON
		-DENABLE_ENCRYPTED_MEDIA=OFF
		-DENABLE_EXPERIMENTAL_FEATURES=$(usex experimental)
		-DENABLE_GTKDOC=$(usex doc)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DENABLE_WPE_QT_API=$(usex qt)
		-DENABLE_MINIBROWSER=$(usex examples)
		-DENABLE_VIDEO=$(usex gstreamer)
		-DENABLE_WEB_AUDIO=$(usex gstreamer)
		-DENABLE_WEBDRIVER=$(usex webdriver)
		-DENABLE_WEB_CRYPTO=$(usex webcrypto)
		-DENABLE_XSLT=ON
		${ruby_interpreter}
	)

	cmake_src_configure
}
