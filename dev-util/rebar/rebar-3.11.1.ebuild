# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 rebar3

DESCRIPTION="Sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://www.rebar3.org/"
LICENSE="Apache-2.0"
SRC_URI="https://github.com/erlang/rebar3/archive/3.11.1.tar.gz -> ${P}.tar.gz"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RESTRICT="network-sandbox"

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}3-${PV}"

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
}
