# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A pass extension for managing one-time-password (OTP) tokens."
HOMEPAGE="https://github.com/tadfisher/pass-otp"
SRC_URI="https://github.com/tadfisher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qrcode"

RDEPEND=">=app-admin/pass-1.7
	qrcode? ( media-gfx/qrencode )
	sys-auth/oath-toolkit"

src_compile() {
	:
}

pkg_postinst() {
	elog "'PASSWORD_STORE_ENABLE_EXTENSIONS=true' is needed to run 'pass otp'."
}
