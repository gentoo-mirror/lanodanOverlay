# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A standalone utility to process systemd-style tmpfiles.d files"
HOMEPAGE="https://github.com/KenjiBrown/hardenedtmpfiles"
SRC_URI="https://github.com/KenjiBrown/hardenedtmpfiles/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="BSD-2"
SLOT="0"

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	for i in opentmpfiles-dev opentmpfiles-setup; do
		newconfd openrc/${i}.confd ${i}
		newinitd openrc/${i}.initd ${i}
	done
}
