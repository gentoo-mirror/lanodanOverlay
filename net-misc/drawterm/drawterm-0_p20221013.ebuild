# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.9front.org/plan9front/drawterm"
else
	EGIT_COMMIT="65e8a26e1dac4a0f589f615126ad87a92c9c11ab"
	SRC_URI="http://git.9front.org/git/plan9front/drawterm/${EGIT_COMMIT}/snap.tar.gz -> drawterm-${EGIT_COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~riscv ~sparc ~x86"
	S="${WORKDIR}/drawterm"
fi

DESCRIPTION="Connect to Plan 9 CPU servers from other operating systems"
HOMEPAGE="https://drawterm.9front.org/"
LICENSE="MIT"
SLOT="0"
USE_AUDIO="alsa pipewire sndio"
USE_GUI="fbdev wayland X"
IUSE="${USE_AUDIO} ${USE_GUI}"
REQUIRED_USE="?? ( ${USE_AUDIO} ) ^^ ( ${USE_GUI} )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	pipewire? ( media-video/pipewire:= )
	sndio? ( media-sound/sndio:= )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		x11-libs/libxkbcommon[wayland]
	)
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

src_configure() {
	export CONF=linux

	export CFLAGS="${CFLAGS} -I\$(ROOT) -I\$(ROOT)/include -I\$(ROOT)/kern -c -D_THREAD_SAFE \$(PTHREAD)"
	export LDFLAGS="${LDFLAGS} -pthread"
	export LDADD="-ggdb -lm"

	if use alsa; then
		export AUDIO="alsa"
		deps="alsa"
	elif use pipewire; then
		export AUDIO="pipewire"
		deps="libpipewire-0.3"
	elif use sndio; then
		export AUDIO="sndio"
		deps="sndio"
	else
		export AUDIO="none"
	fi

	if use fbdev; then
		export GUI="fbdev"
	elif use wayland; then
		export GUI="wl"
		deps="${deps} wayland-client xkbcommon"
	elif use X; then
		export GUI="x11"
		deps="${deps} x11"
	fi

	export CFLAGS="${CFLAGS} $(pkg-config --cflags "${deps}")"
	export LDADD="${LDADD} $(pkg-config --libs "${deps}")"
}

src_compile() {
	emake \
		AS="${AS}" AR="${AR}" RANLIB="${RANLIB}" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		LDADD="${LDADD}" GUI="${GUI}" AUDIO="${AUDIO}"
}

src_install() {
	dobin drawterm
	doman drawterm.1
}
