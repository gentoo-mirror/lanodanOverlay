# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [ "${PV}" == "9999" ]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Neilpang/acme.sh"
else
	SRC_URI="https://github.com/Neilpang/acme.sh/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/acme.sh-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="pure Unix shell script implementing ACME client protocol"
HOMEPAGE="https://acme.sh/"
LICENSE="GPL-3"
SLOT="0"
IUSE="standalone"
RDEPEND="
	net-misc/curl
	|| ( dev-libs/openssl:0 )
	standalone? ( net-misc/socat )
	virtual/cron
"

src_install() {
	einstalldocs
	newdoc dnsapi/README.md README-dnsapi.md
	newdoc deploy/README.md README-deploy.md

	exeinto /usr/share/acme.sh
	doexe acme.sh

	for i in dnsapi deploy
	do
		insinto "/usr/share/acme.sh/$i"
		doins -r "$i/"*.sh
	done

	dosym ../share/acme.sh/acme.sh usr/bin/acme.sh

	einfo "Recommended way to use this ebuild:"
	einfo "- Create a acme user in a new 'certs' group"
	einfo "- Create a shared directory owned by acme:certs"
	einfo "- Put nginx and other daemons using the certificates into the 'certs' groups and configure them to use the shared directory"
}
