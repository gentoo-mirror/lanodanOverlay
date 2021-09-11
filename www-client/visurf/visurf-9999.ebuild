# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit netsurf desktop git-r3

DESCRIPTION="power-user frontend for netsurf"
HOMEPAGE="https://git.sr.ht/~sircmpwn/visurf"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/visurf"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="bmp duktape truetype +gif javascript +jpeg mng
	+png +psl rosprite +svg +svgtiny +webp"

REQUIRED_USE="duktape? ( javascript )"

RDEPEND="
	>=dev-libs/libcss-9999
	>=net-libs/libdom-0.3
	>=net-libs/libhubbub-0.3
	>=dev-libs/libnsutils-0.1.0
	dev-libs/libxml2:2
	net-misc/curl
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/pango
	x11-libs/libxkbcommon
	bmp? ( >=media-libs/libnsbmp-0.1 )
	gif? ( >=media-libs/libnsgif-0.1 )
	javascript? (
		>=dev-libs/nsgenbind-0.7
		duktape? ( dev-lang/duktape:= )
		!duktape? ( dev-lang/spidermonkey:0= )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0 )
	mng? ( >=media-libs/libmng-1.0.10-r2 )
	png? ( >=media-libs/libpng-1.2.51:0 )
	psl? ( media-libs/libnspsl )
	rosprite? ( >=media-libs/librosprite-0.1.2-r1 )
	svg? ( svgtiny? ( >=media-libs/libsvgtiny-0.1.3-r1 )
		!svgtiny? ( gnome-base/librsvg:2 ) )
	webp? ( >=media-libs/libwebp-0.3.0 )"
BDEPEND="
	duktape? ( app-editors/vim-core )
	dev-libs/check
	dev-perl/HTML-Parser
	>=dev-util/netsurf-buildsystem-1.7-r1
	virtual/pkgconfig
	dev-libs/wayland-protocols
"

PATCHES=(
	"${FILESDIR}/netsurf-3.10-julia-libutf8proc-header-location.patch"
)

src_prepare() {
	default
	# do not delete gtk frontend, virsurf/res uses gtk/res
	rm -r frontends/{amiga,atari,beos,monkey,riscos,windows,framebuffer} || die
	mkdir -p build/Linux-visurf || die
}

_emake() {
	netsurf_define_makeconf
	local netsurf_makeconf=(
		"${NETSURF_MAKECONF[@]}"
		COMPONENT_TYPE=binary
		NETSURF_USE_BMP=$(usex bmp YES NO)
		NETSURF_USE_GIF=$(usex gif YES NO)
		NETSURF_USE_JPEG=$(usex jpeg YES NO)
		NETSURF_USE_PNG=$(usex png YES NO)
		NETSURF_USE_NSPSL=$(usex psl YES NO)
		NETSURF_USE_MNG=$(usex mng YES NO)
		NETSURF_USE_WEBP=$(usex webp YES NO)
		NETSURF_USE_MOZJS=$(usex javascript $(usex duktape NO YES) NO)
		NETSURF_USE_JS=NO
		NETSURF_USE_DUKTAPE=$(usex javascript $(usex duktape YES NO) NO)
		NETSURF_USE_NSSVG=$(usex svg $(usex svgtiny YES NO) NO)
		NETSURF_USE_RSVG=$(usex svg $(usex svgtiny NO YES) NO)
		NETSURF_USE_ROSPRITE=$(usex rosprite YES NO)
		PKG_CONFIG=$(tc-getPKG_CONFIG)
		NETSURF_FB_FONTLIB=$(usex truetype freetype internal)
		NETSURF_FB_FONTPATH="${EPREFIX}/usr/share/fonts/dejavu"
		NETSURF_USE_VIDEO=NO
		TARGET=visurf
	)
	emake "${netsurf_makeconf[@]}" $@
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" install
	make_desktop_entry "${EPREFIX}"/usr/bin/netsurf-vi \
		NetSurf-vi \
		netsurf \
		"Network;WebBrowser"
}
