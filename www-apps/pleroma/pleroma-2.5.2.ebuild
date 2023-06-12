# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION="ActivityPub social networking software compatible with other Fediverse software"
HOMEPAGE="https://pleroma.social/"
SRC_URI="https://git.pleroma.social/pleroma/pleroma/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"
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

	cd "${S}" || die
	emix deps.get --only prod
}

src_prepare() {
	default

	echo "import Mix.Config" > config/prod.secret.exs || die
}

src_compile() {
	mkdir -p pleroma || die
	emix release --path pleroma
}

src_install() {
	insinto /opt/
	doins -r pleroma
}
