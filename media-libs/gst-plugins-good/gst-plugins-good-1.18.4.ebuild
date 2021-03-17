# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="alpha apetag audiofx audioparsers auparse autodetect avi cutter debugutils deinterlace dtmf effectv equalizer flv flx goom goom2k1 icydemux id3demux imagefreeze interleave isomp4 law level matroska monoscope multifile multipart replaygain rtp rtpmanager rtsp shapewipe smpte spectrum udp videobox videocrop videofilter videomixer wavenc wavparse y4m"

inherit flag-o-matic gstreamer-meson

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="+orc"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

DOCS="AUTHORS ChangeLog NEWS README RELEASE"

multilib_src_configure() {
	local emesonargs=( -Dbz2=enabled )

	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
