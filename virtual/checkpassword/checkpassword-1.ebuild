# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for checkpassword compatible applications"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="|| (
	net-mail/checkpassword-ng
	net-mail/checkpassword
	net-mail/checkpassword-pam
	net-mail/vpopmail
)"
