# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gstreamer-meson

MY_PN="gst-libav"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${MY_PV}"
FFMPEG_PV="$(ver_cut 4- ${PV%_*})"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-video/ffmpeg-4:0=[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

S="${WORKDIR}/${MY_P}"

RESTRICT="test" # FIXME: tests seem to get stuck at one point; investigate properly
