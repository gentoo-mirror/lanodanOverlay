# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix optfeature

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
IUSE=""

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
	acct-group/pleroma
	dev-db/postgresql[uuid]
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

	# Default ends up being inside /opt/pleroma which should be kept read-only to pleroma
	echo 'config :tzdata, :data_dir, "/var/lib/pleroma/tzdata"' >> config/prod.exs || die

	echo "import Config" > config/prod.secret.exs || die
}

src_compile() {
	mkdir -p pleroma || die
	emix release --overwrite --path pleroma
}

src_install() {
	# doins doesn't seems to preserve permissions
	mkdir -p "${ED}/opt" || die
	cp -pr ./pleroma "${ED}/opt/pleroma" || die
	fperms 0750 /opt/pleroma
	fowners 0:pleroma /opt/pleroma

	dosym /opt/pleroma/bin/pleroma /usr/bin/pleroma
	dosym /opt/pleroma/bin/pleroma_ctl /usr/bin/pleroma_ctl

	# This file controls console access
	fperms 0750 /opt/pleroma/releases/COOKIE
	fowners 0:pleroma /opt/pleroma/releases/COOKIE

	keepdir /etc/pleroma
	fperms 0750 /etc/pleroma
	fowners 0:pleroma /etc/pleroma

	keepdir /var/lib/pleroma
	fperms 0750 /var/lib/pleroma
	fowners pleroma:pleroma /var/lib/pleroma
}

pkg_postinst() {
	optfeature "For Pleroma.Upload.Filters.{Mogrify,Mogrifun} and still image support in Media Preview Proxy" media-gfx/imagemagick
	optfeature "For video support in Media Preview Proxy" media-video/ffmpeg
	optfeature "For Pleroma.Upload.Filters.Exiftool.* filters" media-libs/exiftool
}
