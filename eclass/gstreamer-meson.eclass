# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gstreamer-meson.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# Steven Newbury
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# @SUPPORTED_EAPIS: 7
# @BLURB: Helps building core & split gstreamer plugins.
# @DESCRIPTION:
# Eclass to make external gst-plugins emergable on a per-plugin basis
# and to solve the problem with gst-plugins generating far too much
# unneeded dependencies.
#
# GStreamer consuming applications should depend on the specific plugins
# they need as defined in their source code. Usually you can find that
# out by grepping the source tree for 'factory_make'. If it uses playbin
# plugin, consider adding media-plugins/gst-plugins-meta dependency, but
# also list any packages that provide explicitly requested plugins.

inherit multilib meson toolchain-funcs xdg-utils multilib-minimal

case "${EAPI:-0}" in
	7)
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported"
		;;
esac

# @ECLASS-VARIABLE: GST_PLUGINS_ENABLED
# @DESCRIPTION:
# Defines the plugins to be built.
# May be set by an ebuild and contain more than one indentifier, space
# seperated (only src_configure can handle mutiple plugins at this time).
: ${GST_PLUGINS_ENABLED:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_PLUGINS_DISABLED
# @DESCRIPTION:
# Defines the plugins to not be built, GST_PLUGINS_ENABLED overrides it.
# May be set by an ebuild and contain more than one indentifier, space
# seperated (only src_configure can handle mutiple plugins at this time).
case "${GST_ORG_MODULE}" in
	# copied GST_PLUGINS_DISABLED from media-libs/${GST_ORG_MODULE} then added GST_PLUGINS_ENABLED
	gst-plugins-bad)
		# removed from list: shm ipcpipeline gl
		GST_PLUGINS_DISABLED="aom avtp androidmedia applemedia assrender bluez bs2b bz2 chromaprint closedcaption colormanagement curl curl-ssh2 d3dvideosink d3d11 dash dc1394 decklink directfb directsound dtls dts dvb faac faad fbdev fdkaac flite fluidsynth gme gsm iqa kate kms ladspa libde265 libmms lv2 mediafoundation microdns modplug mpeg2enc mplex msdk musepack neon nvcodec ofa openal openexr openh264 openjpeg openmpt openni2 opensles opus resindvd rsvg rtmp sbc sctp smoothstreaming sndfile soundtouch spandsp srt srtp svthevcenc teletext tinyalsa transcode ttml uvch264 va voaacenc voamrwbenc vulkan wasapi wasapi2 webp webrtc webrtcdsp wildmidi winks winscreencap x265 zbar zxing wpe magicleap v4l2codecs hls opencv"
		GST_PLUGINS_DISABLED="${GST_PLUGINS_DISABLED} accurip adpcmdec adpcmenc aiff asfmux audiobuffersplit audiofxbad audiolatency audiomixmatrix audiovisualizers autoconvert bayer camerabin2 coloreffects deb ugutils dvbsubenc dvbsuboverlay dvdspu faceoverlay festival fieldanalysis freeverb frei0r gaudieffects gdp geometrictransform id3tag inter interlace ivfpars e ivtc jp2kdecimator jpegformat librfb midi mpegdemux mpegpsmux mpegtsdemux mpegtsmux mxf netsim onvif pcapparse pnm proxy rawparse removesilence rist rtmp2 rtp sdp segmentclip siren smooth speed subenc switchbin timecode videofilters videoframe_audiolevel videoparsers videosignal vmnc y4m"
		;;
	gst-plugins-base)
		GST_PLUGINS_DISABLED="cdparanoia libvisual opus tremor"
		GST_PLUGINS_DISABLED="${GST_PLUGINS_DISABLED} adder app audioconvert audiomixer audiorate audioresample audiotestsrc compositor encoding gio gio-typefinder overlaycomposition pbtypes playback rawparse subparse tcp typefind videoconvert videorate videoscale videotestsrc volume"
		;;
	gst-plugins-good)
		GST_PLUGINS_DISABLED="aalib cairo directsound dv dv1394 flac gdk-pixbuf gtk3 jack jpeg lame libcaca mpg123 oss oss4 osxaudio osxvideo png pulse qt5 shout2 soup speex taglib twolame vpx waveform wavpack  rpicamsrc ximagesrc v4l2"
		GST_PLUGINS_DISABLED="${GST_PLUGINS_DISABLED} alpha apetag audiofx audioparsers auparse autodetect avi cutter debugutils deinterlace dtmf effectv equalizer flv flx goom goom2k1 icydemux id3demux imagefreeze interleave isomp4 law level matroska monoscope multifile multipart replaygain rtp rtpmanager rtsp shapewipe smpte spectrum udp videobox videocrop videofilter videomixer wavenc wavparse y4m"
		;;
	gst-plugins-ugly)
		GST_PLUGINS_DISABLED="a52dec amrnb amrwbdec cdio dvdread mpeg2dec sidplay x264"
		GST_PLUGINS_DISABLED="${GST_PLUGINS_DISABLED} asfdemux dvdlpcmdec dvdsub realmedia xingmux"
		;;
esac

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD_DIR
# @DESCRIPTION:
# Actual build directory of the plugin.
# Most often the same as the configure switch name.
: ${GST_PLUGINS_BUILD_DIR:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_TARBALL_SUFFIX
# @DESCRIPTION:
# Most projects hosted on gstreamer.freedesktop.org mirrors provide
# tarballs as tar.bz2 or tar.xz. This eclass defaults to xz. This is
# because the gstreamer mirrors are moving to only have xz tarballs for
# new releases.
: ${GST_TARBALL_SUFFIX:="xz"}

# Even though xz-utils are in @system, they must still be added to BDEPEND; see
# https://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
if [[ ${GST_TARBALL_SUFFIX} == "xz" ]]; then
	BDEPEND="${BDEPEND} app-arch/xz-utils"
fi

# @ECLASS-VARIABLE: GST_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gstreamer.freedesktop.org mirrors.
# Leave unset if package name matches module name.
: ${GST_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GST_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GST_ORG_PVP:=$(ver_cut 1-2)}


DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.${GST_TARBALL_SUFFIX}"

LICENSE="GPL-2"
case ${GST_ORG_PVP} in
	1.*) SLOT="1.0"; GST_MIN_PV="1.2.4-r1" ;;
	*) die "Unkown gstreamer release."
esac

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${GST_MIN_PV}:${SLOT}[${MULTILIB_USEDEP}]
"
BDEPEND="
	>=sys-apps/sed-4
	virtual/pkgconfig
"

# Export common multilib phases.
multilib_src_configure() { gstreamer_multilib_src_configure; }

if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
	# Do not run test phase for invididual plugin ebuilds.
	RESTRICT="test"
	RDEPEND="${RDEPEND}
		>=media-libs/${GST_ORG_MODULE}-${PV}:${SLOT}[${MULTILIB_USEDEP}]"

	# Export multilib phases used for split builds.
	multilib_src_compile() { gstreamer_multilib_src_compile; }
	multilib_src_install() { gstreamer_multilib_src_install; }
	multilib_src_install_all() { gstreamer_multilib_src_install_all; }
else
	IUSE="nls test"
	RESTRICT="!test? ( test )"
	BDEPEND="${DEPEND}
		nls? ( >=sys-devel/gettext-0.17 )
		test? ( media-libs/gstreamer[test] )
	"

	multilib_src_compile() { eninja; }
	multilib_src_test() { eninja test; }
	multilib_src_install() { DESTDIR="${D}" eninja install; }
fi

DEPEND="${DEPEND} ${RDEPEND}"

# @FUNCTION: gstreamer_environment_reset
# @INTERNAL
# @DESCRIPTION:
# Clean up environment for clean builds.
# >=dev-lang/orc-0.4.23 rely on environment variables to find a place to
# allocate files to mmap.
gstreamer_environment_reset() {
	xdg_environment_reset
}

# @FUNCTION: gstreamer_get_plugin_dir
# @USAGE: gstreamer_get_plugin_dir [<build_dir>]
# @INTERNAL
# @DESCRIPTION:
# Finds plugin build directory and output it.
# Defaults to ${GST_PLUGINS_BUILD_DIR} if argument is not provided
gstreamer_get_plugin_dir() {
	local build_dir=${1:-${GST_PLUGINS_BUILD_DIR}}

	if [[ ! -d ${S}/ext/${build_dir} ]]; then
		if [[ ! -d ${S}/sys/${build_dir} ]]; then
			ewarn "No such plugin directory"
			die
		fi
		einfo "Building system plugin in ${build_dir}..." >&2
		echo sys/${build_dir}
	else
		einfo "Building external plugin in ${build_dir}..." >&2
		echo ext/${build_dir}
	fi
}

# @FUNCTION: gstreamer_multilib_src_configure
# @DESCRIPTION:
# Handles logic common to configuring gstreamer plugins
gstreamer_multilib_src_configure() {
	local plugin gst_conf=( ) EMESON_SOURCE=${EMESON_SOURCE:-${S}}

	gstreamer_environment_reset

	# app-editor/vis regex for meson_options.txt: :x/option\('([^']*)'.*/ c/\1/
	for plugin in ${GST_PLUGINS_DISABLED} ; do
		gst_conf+=( -D${plugin}=disabled )
	done

	for plugin in ${GST_PLUGINS_ENABLED} ; do
		gst_conf+=( -D${plugin}=enabled )
	done

	if grep -q "option('orc'" "${EMESON_SOURCE}"/meson_options.txt ; then
		if in_iuse orc ; then
			gst_conf+=( -Dorc=$(usex orc enabled disabled) )
		else
			gst_conf+=( -Dorc=disabled )
		fi
	fi

	if grep -q "option(\'maintainer-mode\'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dmaintainer-mode=disabled )
	fi

	if grep -q "option(\'schemas-compile\'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dschemas-compile=disabled )
	fi

	if [[ ${PN} == ${GST_ORG_MODULE} ]]; then
		gst_conf+=( $(meson_feature nls) )
	fi

	einfo "Configuring to build ${GST_PLUGINS_ENABLED} plugin(s) ..."
	gst_conf+=(
		-Dexamples=disabled
		-Dpackage-name="Gentoo GStreamer ebuild"
		-Dpackage-origin="https://www.gentoo.org"
		-Dgst_debug=false
		$(meson_feature test tests)
		"${@}"
	)
	meson_src_configure "${gst_conf[@]}"
}


# @FUNCTION: _gstreamer_get_target_filename
# @INTERNAL
# @DESCRIPTION:
# Extracts build and target filenames from meson-data for given submatch
_gstreamer_get_target_filename() {
	cat >"${WORKDIR}/_gstreamer_get_target_filename.py" <<"EOF"
import json
import sys

with open("meson-info/intro-targets.json", "r") as targets_file:
	data = json.load(targets_file)

for i in range(len(data)):
	target = data[i]
	if target['installed']:
		if sys.argv[1] in target['filename'][0]:
			print(target['filename'][0] + ':' + target['install_filename'][0])
EOF

	${EPYTHON} "${WORKDIR}/_gstreamer_get_target_filename.py" $@ \
		|| die "Failed to extract target filenames from meson-data"
}

# @FUNCTION: gstreamer_multilib_src_compile
# @DESCRIPTION:
# Compiles requested gstreamer plugin.
gstreamer_multilib_src_compile() {
	local plugin_dir plugin

	for plugin_dir in "${GST_PLUGINS_BUILD_DIR}" ; do
		plugin=$(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir}))
		plugin_path="${plugin%%:*}"
		eninja "${plugin_path/"${BUILD_DIR}/"}"
	done
}

# @FUNCTION: gstreamer_multilib_src_install
# @DESCRIPTION:
# Installs requested gstreamer plugin.
gstreamer_multilib_src_install() {
	local plugin_dir plugin

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		for plugin in $(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir})); do
			local install_filename="${plugin##*:}"
			insinto "${install_filename%/*}"
			doins "${plugin%%:*}"
		done
	done
}

# @FUNCTION: gstreamer_multilib_src_install_all
# @DESCRIPTION:
# Installs documentation for requested gstreamer plugin, and removes .la
# files.
gstreamer_multilib_src_install_all() {
	local plugin_dir

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		local dir=$(gstreamer_get_plugin_dir ${plugin_dir})
		[[ -e ${dir}/README ]] && dodoc "${dir}"/README
	done

	prune_libtool_files --modules
}
