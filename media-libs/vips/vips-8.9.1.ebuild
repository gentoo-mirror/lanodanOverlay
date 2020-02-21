# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils autotools multilib-minimal

DESCRIPTION="VIPS Image Processing Library"
SRC_URI="https://github.com/libvips/libvips/releases/download/v${PV}/${P}.tar.gz"
HOMEPAGE="https://libvips.github.io/libvips/"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug exif fits fftw heif gsf graphicsmagick imagemagick jpeg lcms matio openexr orc pango pdf png svg static-libs tiff webp zlib"

# FIXME: nitfi (FIND_NIFTI)
# openslide? ( >=media-libs/openslide-3.3.0 )
RDEPEND="
	>=dev-libs/glib-2.6:2
	dev-libs/expat:=
	debug? ( dev-libs/dmalloc )
	fftw? ( sci-libs/fftw:3.0= )
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick )
		!graphicsmagick? ( media-gfx/imagemagick )
	)
	exif? ( >=media-libs/libexif-0.6 )
	fits? ( sci-libs/cfitsio )
	heif? ( media-libs/libheif:= )
	jpeg? ( virtual/jpeg:0= )
	gsf? ( gnome-extra/libgsf:= )
	lcms? ( media-libs/lcms )
	matio? ( >=sci-libs/matio-1.3.4 )
	openexr? ( >=media-libs/openexr-1.2.2 )
	orc? ( >=dev-lang/orc-0.4.11 )
	pango? ( x11-libs/pango )
	pdf? ( app-text/poppler[cairo] )
	png? ( >=media-libs/libpng-1.2.9:0= )
	svg? ( gnome-base/librsvg )
	tiff? ( media-libs/tiff:0= )
	webp? ( media-libs/libwebp )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
	doc? (
		dev-util/gtk-doc
		dev-util/gtk-doc-am
	)
"

DOCS=(ChangeLog NEWS THANKS README.md)

src_prepare() {
	default

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local magick="--without-magick";
	use imagemagick && magick="--with-magickpackage=MagickCore"
	use graphicsmagick && magick="--with-magickpackage=GraphicsMagick"

	econf \
		${magick} \
		$(multilib_native_use_enable doc gtk-doc) \
		$(use_enable debug) \
		$(use_with debug dmalloc) \
		$(use_with exif libexif) \
		$(use_with fftw) \
		$(use_with fits cfitsio) \
		$(use_with gsf) \
		$(use_with jpeg) \
		$(use_with lcms) \
		$(use_with matio ) \
		$(use_with openexr OpenEXR) \
#		$(use_with openslide) \
		$(use_with orc) \
		$(use_with pango pangoft2) \
		$(use_with pdf poppler) \
		$(use_with png) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with webp libwebp) \
		$(use_with zlib) \
		$(use_enable static-libs static) \
		--with-html-dir="/usr/share/gtk-doc/html"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}
multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
