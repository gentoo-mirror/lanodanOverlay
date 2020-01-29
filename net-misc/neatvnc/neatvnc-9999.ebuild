# Copyright 2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="liberally licensed VNC server library that's intended to be fast and neat"
HOMEPAGE="https://github.com/any1/neatvnc"
EGIT_REPO_URI="https://github.com/any1/neatvnc.git"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnutls jpeg"

DEPEND="
	x11-libs/pixman:=
	dev-libs/libuv:=
	gnutls? ( net-libs/gnutls:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
"
RDEPEND="
	${DEPEND}
	x11-libs/libdrm
"

src_prepare() {
	default

	# grep -l '"sys/queue.h"' "$S"/include/*.h \
	# 	| xargs sed -i 's;"sys/queue.h";<sys/queue.h>;' \
	# 	|| die 'Failed changing "sys/queue.h" to <sys/queue.h>'
	#
	# rm "${S}/include/sys/queue.h" || die 'Failed removing include/sys/queue.h'

	sed -i '/<sys\/cdefs.h>/d' "${S}/include/sys/queue.h"
}

src_configure() {
	local emesonargs=(
		$(meson_feature jpeg tight-encoding)
		$(meson_feature gnutls tls)
	)

	meson_src_configure
}
