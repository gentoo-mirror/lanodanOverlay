# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="HTTP live streaming plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libaom:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"