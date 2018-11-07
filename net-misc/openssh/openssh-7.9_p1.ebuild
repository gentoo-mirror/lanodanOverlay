# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user flag-o-matic multilib autotools pam systemd

PARCH=${P/_}

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="abi_mips_n32 audit bindist debug kerberos kernel_linux ldns libedit libressl livecd pam +pie selinux +ssl static test X"
RESTRICT="!test? ( test )"
REQUIRED_USE="ldns? ( ssl )
	pie? ( !static )
	static? ( !kerberos !pam )
	test? ( ssl )"

LIB_DEPEND="
	audit? ( sys-process/audit[static-libs(+)] )
	ldns? (
		net-libs/ldns[static-libs(+)]
		!bindist? ( net-libs/ldns[ecdsa,ssl(+)] )
		bindist? ( net-libs/ldns[-ecdsa,ssl(+)] )
	)
	libedit? ( dev-libs/libedit:=[static-libs(+)] )
	selinux? ( >=sys-libs/libselinux-1.28[static-libs(+)] )
	ssl? (
		!libressl? (
			>=dev-libs/openssl-1.0.1:0=[bindist=]
			dev-libs/openssl:0=[static-libs(+)]
		)
		libressl? ( dev-libs/libressl:0=[static-libs(+)] )
	)
	>=sys-libs/zlib-1.2.3:=[static-libs(+)]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	virtual/pkgconfig
	virtual/os-headers
	sys-devel/autoconf"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20081028 )
	userland_GNU? ( virtual/shadow )
	X? ( x11-apps/xauth )"

S="${WORKDIR}/${PARCH}"

src_prepare() {
	default

	eautoreconf

	tc-export PKG_CONFIG
	local sed_args=(
		-e "s:-lcrypto:$(${PKG_CONFIG} --libs openssl):"
		# Disable PATH reset, trust what portage gives us #254615
		-e 's:^PATH=/:#PATH=/:'
		# Disable fortify flags ... our gcc does this for us
		-e 's:-D_FORTIFY_SOURCE=2::'
	)

	sed -i "${sed_args[@]}" configure{.ac,} || die

	eautoreconf
}

src_configure() {
	addwrite /dev/ptmx

	use debug && append-cppflags -DSANDBOX_SECCOMP_FILTER_DEBUG
	use static && append-ldflags -static

	local myconf=(
		--with-ldflags="${LDFLAGS}"
		--disable-strip
		--with-pid-dir="${EPREFIX}"$(usex kernel_linux '' '/var')/run
		--sysconfdir="${EPREFIX%/}"/etc/ssh
		--libexecdir="${EPREFIX%/}"/usr/$(get_libdir)/misc
		--datadir="${EPREFIX%/}"/usr/share/openssh
		--with-privsep-path="${EPREFIX%/}"/var/empty
		--with-privsep-user=sshd
		--with-mantype=doc
		$(use_with audit audit linux)
		$(use_with kerberos kerberos5 "${EPREFIX%/}"/usr)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use_with selinux)
		$(use_with ssl openssl)
		$(use_with ssl md5-passwords)
		$(use_with ssl ssl-engine)
		$(use_with !elibc_Cygwin hardening) #659210
	)

	# stackprotect is broken on musl x86
	use elibc_musl && use x86 && myconf+=( --without-stackprotect )

	# The seccomp sandbox is broken on x32, so use the older method for now. #553748
	use amd64 && [[ ${ABI} == "x32" ]] && myconf+=( --with-sandbox=rlimit )

	econf "${myconf[@]}"
}

src_test() {
	local t skipped=() failed=() passed=()
	local tests=( interop-tests compat-tests )

	local shell=$(egetshell "${UID}")
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		elog "Running the full OpenSSH testsuite requires a usable shell for the 'portage'"
		elog "user, so we will run a subset only."
		skipped+=( tests )
	else
		tests+=( tests )
	fi

	# It will also attempt to write to the homedir .ssh.
	local sshhome=${T}/homedir
	mkdir -p "${sshhome}"/.ssh
	for t in "${tests[@]}" ; do
		# Some tests read from stdin ...
		HOMEDIR="${sshhome}" HOME="${sshhome}" \
		emake -k -j1 ${t} </dev/null \
			&& passed+=( "${t}" ) \
			|| failed+=( "${t}" )
	done

	einfo "Passed tests: ${passed[*]}"
	[[ ${#skipped[@]} -gt 0 ]] && ewarn "Skipped tests: ${skipped[*]}"
	[[ ${#failed[@]}  -gt 0 ]] && die "Some tests failed: ${failed[*]}"
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd.initd sshd
	newconfd "${FILESDIR}"/sshd-r1.confd sshd

	newpamd "${FILESDIR}"/sshd.pam_include.2 sshd

	doman contrib/ssh-copy-id.1
	dodoc CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh

	keepdir /var/empty

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

pkg_preinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}

pkg_postinst() {
	if has_version "<${CATEGORY}/${PN}-7.6_p1" ; then
		elog "Starting with openssh-7.6p1, openssh upstream has removed ssh1 support entirely."
		elog "Furthermore, rsa keys with less than 1024 bits will be refused."
	fi
	if has_version "<${CATEGORY}/${PN}-7.7_p1" ; then
		elog "Starting with openssh-7.7p1, we no longer patch openssh to provide LDAP functionality."
		elog "Install sys-auth/ssh-ldap-pubkey and use OpenSSH's \"AuthorizedKeysCommand\" option"
		elog "if you need to authenticate against LDAP."
		elog "See https://wiki.gentoo.org/wiki/SSH/LDAP_migration for more details."
	fi
	if ! use ssl && has_version "${CATEGORY}/${PN}[ssl]" ; then
		elog "Be aware that by disabling openssl support in openssh, the server and clients"
		elog "no longer support dss/rsa/ecdsa keys.  You will need to generate ed25519 keys"
		elog "and update all clients/servers that utilize them."
	fi
}
