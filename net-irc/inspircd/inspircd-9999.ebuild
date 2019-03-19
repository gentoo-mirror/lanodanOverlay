# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs user

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="http://www.inspircd.org/"
if [[ "${PV}" == "9999" ]]
then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/inspircd/inspircd.git"
else
	SRC_URI="https://github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="geoip gnutls ldap libressl mbedtls mysql pcre posix postgres sqlite openssl sslrehash tre"

REQUIRED_USE="sslrehash? ( || ( gnutls mbedtls openssl ) )"

RDEPEND="
	dev-lang/perl
	dev-libs/utfcpp:=
	openssl? (
		!libressl? ( dev-libs/openssl:= )
		libressl? ( dev-libs/libressl:= )
	)
	geoip? ( dev-libs/geoip )
	gnutls? ( net-libs/gnutls:= dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap )
	mysql? ( dev-db/mysql-connector-c:= )
	mbedtls? ( net-libs/mbedtls:= )
	postgres? ( dev-db/postgresql:= )
	pcre? ( dev-libs/libpcre )
	sqlite? ( >=dev-db/sqlite-3.0 )
	tre? ( dev-libs/tre )
"
DEPEND="${RDEPEND}"

DOCS=( docs/. )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default

	rm -r vendor/utfcpp || die "Failed removing bundling of utfcpp"
	grep -l 'vendor_directory("utfcpp")' -r src | xargs sed -i 's/vendor_directory("utfcpp")/utf8/' || die "Failed changing the flag for utfcpp"
}

src_configure() {
	local extras=""

	tc-export CXX

	# NOTE: remove when modulemanager is rewrote
	# extra modules are found in src/modules/extra
	use geoip && extras+="m_geoip.cpp,"
	use gnutls && extras+="m_ssl_gnutls.cpp,"
	use ldap && extras+="m_ldapauth.cpp,m_ldapoper.cpp,"
	use mysql && extras+="m_mysql.cpp,"
	use pcre && extras+="m_regex_pcre.cpp,"
	use posix && extras+="m_regex_posix.cpp,"
	use postgres && extras+="m_pgsql.cpp,"
	use sqlite && extras+="m_sqlite3.cpp,"
	use openssl && extras+="m_ssl_openssl.cpp,"
	use tre && extras+="m_regex_tre.cpp,"
	use mbedtls && extras+="m_ssl_mbedtls.cpp,"
	use sslrehash && extras+="m_sslrehashsignal.cpp,"

	# The first configuration run enables certain "extra" InspIRCd
	# modules, the second run generates the actual makefile.
	if [[ -n "${extras}" ]]; then
		./configure --disable-interactive --enable-extras=${extras%,}
	fi

	# Remove --development on stable release ebuild
	local myconf=(
		--disable-interactive
		--development
		--prefix="/usr/$(get_libdir)/${PN}"
		--config-dir="/etc/${PN}"
		--data-dir="/var/lib/${PN}/data"
		--log-dir="/var/log/${PN}"
		--binary-dir="/usr/bin"
		--module-dir="/usr/$(get_libdir)/${PN}/modules"
		--gid=${PN}
		--uid=${PN}
	)

	./configure "${myconf[@]}"
}

src_compile() {
	emake V=1 LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake INSTUID=${PN} DESTDIR="${D%/}" install

	insinto "/usr/include/${PN}"
	doins -r include/.

	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/log/${PN}"

	diropts -o"${PN}" -g"${PN}" -m0700
	keepdir "/var/lib/${PN}/data"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "You will find example configuration files under "
		elog "/usr/share/doc/${PN}"
		elog "Read the ${PN}.conf.example file carefully before "
		elog "starting the service."
	fi
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ver_test "${pv}" -lt "2.0.24-r1"; then
			elog "Starting with 2.0.24-r1 the daemon is no longer started"
			elog "with the --logfile option and you are thus expected to define"
			elog "logging in the InspIRCd configuration file if you want it."
			break
		fi
	done
}
