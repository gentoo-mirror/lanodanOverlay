# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION="ActivityPub social networking software compatible with other Fediverse software"
HOMEPAGE="https://pleroma.social/"
if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pleroma.social/pleroma/pleroma"
	# git-r3 doesn't allows make.conf override of MIN_CLONE_TYPE, so done here for my self-hosted branch
	EGIT_MIN_CLONE_TYPE="single+tags"
else
	SRC_URI="https://git.pleroma.social/pleroma/pleroma/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
fi
LICENSE="AGPL-3 CC-BY-SA-4.0 CC-BY-4.0"
SLOT="otp"
KEYWORDS="~amd64"
IUSE="imagemagick ffmpeg exiftool"

# Requires network access (https) as long as elixir dependencies aren't packaged
# said dependencies have their checksum verified via `mix.lock`
RESTRICT="network-sandbox"

BDEPEND="
	dev-lang/erlang:=
	dev-lang/elixir:=
	dev-util/cmake
	dev-util/rebar
	dev-elixir/hex
"
DEPEND="
	sys-libs/ncurses:=
	sys-apps/file
"
RDEPEND="
	${DEPEND}
	acct-user/pleroma
	imagemagick? ( media-gfx/imagemagick )
	ffmpeg? ( media-video/ffmpeg )
	exiftool? ( media-libs/exiftool )
"

src_unpack() {
	default

	[[ "${PV}" == *9999 ]] && git-r3_src_unpack

	cd "${S}" || die
	emix deps.get --only prod
}

src_prepare() {
	default

	# Point to the correct source repo, needed for AGPL compliance
	if [[ "${PV}" == *9999 ]] && [[ -n "${EGIT_OVERRIDE_REPO}" ]]; then
		sed -i "s!source_url: .*!source_url: \"${EGIT_OVERRIDE_REPO}\",!" mix.exs || die
	fi

	sed -i -e '/include_executables_for:/a\          strip_beams: false,\n\          include_erts: false,' mix.exs || die

	sed -i \
		-e '/update \[OPTIONS\]/,/--tmp-dir/d' \
		-e 's;update "$@";echo "Unsupported, check the '"${CATEGORY}/${PN}"' package instead.";' \
		rel/files/bin/pleroma_ctl || die

	echo "import Mix.Config" > config/prod.secret.exs || die
}

src_compile() {
	mkdir -p pleroma || die
	emix release --overwrite --path pleroma
}

src_install() {
	insinto /opt/
	doins -r pleroma
}
