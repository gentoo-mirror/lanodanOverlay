# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Adobe Flash Player standalone projector"
HOMEPAGE="https://www.adobe.com/support/flashplayer/debug_downloads.html"

SRC_URI="
	!debugger? ( https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz )
	debugger? ( https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux_debug.x86_64.tar.gz )
"
S="${WORKDIR}"

LICENSE="Adobe"
SLOT="32"
KEYWORDS="~amd64"
IUSE="debugger"

DEPEND=""
RDEPEND="
	${DEPEND}
	media-libs/libglvnd[X]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrender
	dev-libs/nss
	dev-libs/nspr
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	media-libs/fontconfig
	dev-libs/glib
	media-libs/freetype
"

QA_PREBUILT="/usr/bin/flashplayer"

src_install(){
	if ( use debugger ); then
		newbin flashplayerdebugger flashplayer
	else
		dobin flashplayer
	fi
}
