# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# N.B.: It is no clue in porting to Lua eclasses, as upstream have deviated
# too far from vanilla Lua, adding their own APIs like lua_enablereadonlytable

inherit edo multiprocessing systemd tmpfiles toolchain-funcs

if [ ${PV} = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~lanodan/redict"
else
	die "live-only for now"
	KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="A persistent caching system, key-value, and data structures database (personal branch!)"
HOMEPAGE="
	https://git.sr.ht/~lanodan/redict
	https://codeberg.org/redict/redict
"

LICENSE="BSD Boost-1.0 GPL-3"
SLOT="0/$(ver_cut 1-2)"
IUSE="+jemalloc selinux ssl systemd tcmalloc test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

COMMON_DEPEND="
	jemalloc? ( >=dev-libs/jemalloc-5.1:= )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tcmalloc? ( dev-util/google-perftools )
"

RDEPEND="
	${COMMON_DEPEND}
	acct-group/redis
	acct-user/redis
	selinux? ( sec-policy/selinux-redis )
"

BDEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

# Tcl is only needed in the CHOST test env
DEPEND="
	${COMMON_DEPEND}
	test? (
		dev-lang/tcl:0=
		ssl? ( dev-tcltk/tls )
	)"

PATCHES=(
	"${FILESDIR}"/redict-6.2.1-config.patch
	"${FILESDIR}"/redict-sentinel-7.2.0-config.patch
)

src_prepare() {
	default

	# Respect user CFLAGS in bundled lua
	sed -i '/LUA_CFLAGS/s: -O2::g' deps/Makefile || die
}

src_compile() {
	tc-export AR CC RANLIB

	local myconf=(
		AR="${AR}"
		CC="${CC}"
		RANLIB="${RANLIB}"

		V=1 # verbose

		# OPTIMIZATION defaults to -O3. Let's respect user CFLAGS by setting it
		# to empty value.
		OPTIMIZATION=''
		# Disable debug flags in bundled hiredis
		DEBUG_FLAGS=''

		BUILD_TLS=$(usex ssl)
		USE_SYSTEMD=$(usex systemd)
	)

	if use jemalloc; then
		myconf+=( MALLOC=jemalloc )
	elif use tcmalloc; then
		myconf+=( MALLOC=tcmalloc )
	else
		myconf+=( MALLOC=libc )
	fi

	emake -C src "${myconf[@]}"
}

src_test() {
	local runtestargs=(
		--clients "$(makeopts_jobs)" # see bug #649868

		--skiptest "Active defrag eval scripts" # see bug #851654
	)

	if has usersandbox ${FEATURES} || ! has userpriv ${FEATURES}; then
		ewarn "oom-score-adj related tests will be skipped." \
			"They are known to fail with FEATURES usersandbox or -userpriv. See bug #756382."

		runtestargs+=(
			# unit/oom-score-adj was introduced in version 6.2.0
			--skipunit unit/oom-score-adj # see bug #756382

			# Following test was added in version 7.0.0 to unit/introspection.
			# It also tries to adjust OOM score.
			--skiptest "CONFIG SET rollback on apply error"
		)
	fi

	if use ssl; then
		edo ./utils/gen-test-certs.sh
		runtestargs+=( --tls )
	fi

	edo ./runtest "${runtestargs[@]}"
}

src_install() {
	insinto /etc/redict
	doins redict.conf sentinel.conf
	use prefix || fowners -R redis:redis /etc/redict /etc/redict/{redict,sentinel}.conf
	fperms 0750 /etc/redict
	fperms 0644 /etc/redict/{redict,sentinel}.conf

	newconfd "${FILESDIR}/redis.confd-r2" redict
	newinitd "${FILESDIR}/redis.initd-6" redict

	systemd_newunit "${FILESDIR}/redis.service-4" redict.service
	newtmpfiles "${FILESDIR}/redis.tmpfiles-2" redict.conf

	newconfd "${FILESDIR}/redis-sentinel.confd-r1" redict-sentinel
	newinitd "${FILESDIR}/redis-sentinel.initd-r1" redict-sentinel

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/redis.logrotate" ${PN}

	dodoc 00-RELEASENOTES BUGS CONTRIBUTING.md MANIFESTO README.md

	dobin src/redict-cli
	dosbin src/redict-benchmark src/redict-server src/redict-check-aof src/redict-check-rdb
	fperms 0750 /usr/sbin/redict-benchmark
	dosym redict-server /usr/sbin/redict-sentinel

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o redis -g redis
	fi
	keepdir /var/{log,lib}/redict
}

pkg_postinst() {
	tmpfiles_process redict.conf

	ewarn "The default redict configuration file location changed to:"
	ewarn "  /etc/redict/{redict,sentinel}.conf"
	ewarn "Please apply your changes to the new configuration files."
}
