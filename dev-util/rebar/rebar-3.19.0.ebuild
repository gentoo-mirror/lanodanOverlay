# Copyright 2019-2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 rebar3

DESCRIPTION="Erlang build tool that makes it easy to compile and test Erlang applications and releases"
HOMEPAGE="https://www.rebar3.org/"
LICENSE="Apache-2.0"
SRC_URI="
	https://github.com/erlang/rebar3/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo.hex.pm/tarballs/bbmustache-1.12.2.tar
	https://repo.hex.pm/tarballs/certifi-2.9.0.tar
	https://repo.hex.pm/tarballs/cf-0.3.1.tar
	https://repo.hex.pm/tarballs/cth_readable-1.5.1.tar
	https://repo.hex.pm/tarballs/erlware_commons-1.5.0.tar
	https://repo.hex.pm/tarballs/eunit_formatters-0.5.0.tar
	https://repo.hex.pm/tarballs/getopt-1.0.1.tar
	https://repo.hex.pm/tarballs/providers-1.9.0.tar
	https://repo.hex.pm/tarballs/relx-4.7.0.tar
	https://repo.hex.pm/tarballs/ssl_verify_fun-1.1.6.tar
	test? ( https://repo.hex.pm/tarballs/meck-0.8.13.tar )
"
S="${WORKDIR}/${PN}3-${PV}"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/erlang[ssl]
	!dev-util/rebar-bin
"
RDEPEND="${DEPEND}"

PATCHES=(
	# The build directory (where dependencies are usually stored) gets
	# cleared before each build.  Make the fetch function first look in
	# a _checkouts directory before going out over the net.
	"${FILESDIR}"/${PN}-3.18.0-bootstrap-vendored.patch
)

src_unpack() {
	# Unpack the rebar sources like normal, but extract the hex.pm
	# dependencies separately.  The outer tarball contains another
	# tarball named contents.tar.gz that actually contains the code.

	local archive
	for archive in ${A}; do
		case "${archive}" in
			# Assume that the .tar files are our hex.pm dependencies.
			*.tar)
				local dest="${S}"/_checkouts/"${archive%-*}"

				mkdir -p "${dest}" || die

				# Extract the inner tarball
				tar -O -xf "${DISTDIR}"/"${archive}" contents.tar.gz |
					tar -xzf - -C "${dest}"

				assert
				;;
			*)
				unpack "${archive}"
				;;
		esac
	done
}

src_compile() {
	./bootstrap || die
}

src_test() {
	./rebar3 ct || die
}

src_install() {
	rebar3_src_install

	dobin rebar3
	doman manpages/rebar3.1
	dodoc rebar.config.sample

	dobashcomp priv/shell-completion/bash/rebar3
	newenvd - 98rebar3 <<< 'REBAR3_CMD='${EPREFIX}'/usr/bin/rebar3'

	insinto /usr/share/fish/completion
	newins priv/shell-completion/fish/rebar3.fish rebar3

	insinto /usr/share/zsh/site-functions
	doins priv/shell-completion/zsh/_rebar3
}
