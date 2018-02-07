# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Modern asynchronous DNS API"
HOMEPAGE="https://getdnsapi.net/"
SRC_URI="https://getdnsapi.net/releases/getdns-1-3-0/getdns-1.3.0.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="stubby libressl"

DEPEND="
	dev-libs/libyaml:=
	!libressl? ( >=dev-libs/openssl-1.0.2:= )
	libressl? ( dev-libs/libressl:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with stubby)
}
