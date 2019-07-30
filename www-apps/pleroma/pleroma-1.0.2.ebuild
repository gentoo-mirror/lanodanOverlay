# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mix

DESCRIPTION="Microblogging software federating over OStatus and ActivityPub"
HOMEPAGE="https://pleroma.social/"
LICENSE="AGPL-3 CC-BY-SA-4.0 Unsplash"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pleroma.social/pleroma/pleroma.git"
else
	SRC_URI="https://git.pleroma.social/pleroma/pleroma/-/archive/v${PV}/pleroma-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64"
fi
SLOT="0"
IUSE=""

# dev-lang/erlang is required for binary compat
DEPEND="
	dev-lang/erlang:=
	>=dev-lang/elixir-1.7:=
	dev-elixir/auto_linker
	>=dev-elixir/cachex-3.0.2
	>=dev-elixir/calendar-0.17.4
	>=dev-elixir/comeonin-4.1.1
	>=dev-elixir/cors_plug-1.5
	>=dev-elixir/credo-0.9.3
	dev-elixir/crypt
	>=dev-elixir/earmark-1.3
	>=dev-elixir/ecto_sql-3.0.5
	>=dev-elixir/ex_aws-2.0
	>=dev-elixir/ex_aws_s3-2.0
	>=dev-elixir/ex_doc-1.5
	>=dev-elixir/ex_machina-2.3
	>=dev-elixir/ex_syslogger-1.4.0
	>=dev-elixir/floki-0.20.0
	>=dev-elixir/gen_smtp-0.13
	>=dev-elixir/gettext-0.15
	>=dev-elixir/html_entities-0.4
	>=dev-elixir/html_sanitize_ex-1.3.0
	>=dev-elixir/httpoison-1.2.0
	>=dev-elixir/jason-1.0
	>=dev-elixir/mock-0.3.1
	>=dev-elixir/mogrify-0.6.1
	>=dev-elixir/pbkdf2_elixir-0.12.3
	>=dev-elixir/phoenix-1.4.1
	>=dev-elixir/phoenix_ecto-4.0
	>=dev-elixir/phoenix_pubsub-1.1
	>=dev-elixir/pleroma_job_queue-0.2.0
	>=dev-elixir/plug_cowboy-2.0
	>=dev-elixir/poison-3.0
	>=dev-elixir/postgrex-0.13.5
	>=dev-elixir/prometheus_ecto-1.4
	>=dev-elixir/prometheus_ex-3.0
	>=dev-elixir/prometheus_pheonix-1.2
	>=dev-elixir/prometheus_plugs-1.1
	>=dev-elixir/quack-0.1.1
	>=dev-elixir/recon-2.4.0
	>=dev-elixir/swoosh-0.20
	>=dev-elixir/telemetry-0.3
	>=dev-elixir/tesla-1.2
	>=dev-elixir/timex-3.5
	>=dev-elixir/trailing_format_plug-0.0.7
	>=dev-elixir/ueberauth-0.4
	>=dev-elixir/web_push_encryption-0.2.1
	dev-elixir/websocket_client
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/pleroma: \[/a\          include_erts: false,' ./mix.exs || die "Failed setting release to: include_erts: false"
	default
}

src_compile() {
	mix release
}
