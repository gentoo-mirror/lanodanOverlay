# Copyright 1999-2022 Gentoo Authors
# Copyright 2018-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam systemd

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="https://www.opensmtpd.org/archives/${P/_}.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE="berkdb +mta pam"

# < openssl 3 for bug #881701
DEPEND="
	acct-user/smtpd
	acct-user/smtpq
	<dev-libs/openssl-3:=
	>=dev-libs/openssl-1.1.0:0=
	sys-libs/zlib
	pam? ( sys-libs/pam )
	berkdb? ( sys-libs/db:= )
	elibc_musl? (
		sys-libs/fts-standalone
		sys-libs/queue-standalone
	)
	dev-libs/libevent
	app-misc/ca-certificates
	net-mail/mailbase
	net-libs/libasr
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta]
"
RDEPEND="${DEPEND}"

# Broken build when libbsd is present at configure time
BDEPEND="!dev-libs/libbsd"

S=${WORKDIR}/${P/_}

src_configure() {
	econf \
		--sysconfdir=/etc/smtpd \
		--with-path-mbox=/var/spool/mail \
		--with-path-empty=/var/empty \
		--with-path-socket=/run \
		--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt \
		--with-user-smtpd=smtpd \
		--with-user-queue=smtpq \
		--with-group-queue=smtpq \
		--with-mantype=doc \
		$(use_with pam auth-pam) \
		$(use_with berkdb table-db)
}

src_install() {
	default

	newinitd "${FILESDIR}"/smtpd.initd smtpd
	systemd_dounit "${FILESDIR}"/smtpd.{service,socket}

	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd

	dosym /usr/sbin/smtpctl /usr/sbin/makemap
	dosym /usr/sbin/smtpctl /usr/sbin/newaliases

	if use mta ; then
		dodir /usr/sbin
		dosym /usr/sbin/smtpctl /usr/sbin/sendmail
		dosym /usr/sbin/smtpctl /usr/bin/sendmail
		dosym /usr/sbin/smtpctl /usr/$(get_libdir)/sendmail
	fi
}
