# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

EAPI="6"
SLOT="7"

inherit autotools check-reqs eutils gnome2-utils java-pkg-2 java-vm-2 multiprocessing pax-utils prefix versionator virtualx

ICEDTEA_VER=$(get_version_component_range 2-4)
ICEDTEA_BRANCH=$(get_version_component_range 2-3)
ICEDTEA_PKG=icedtea-${ICEDTEA_VER}
ICEDTEA_PRE=$(get_version_component_range _)
CORBA_TARBALL="60fb55621427.tar.bz2"
HOTSPOT_TARBALL="d7f4f4901aa1.tar.bz2"
JAXP_TARBALL="2eedd3512498.tar.bz2"
JAXWS_TARBALL="dc69e332d99f.tar.bz2"
JDK_TARBALL="f42b7efa98fe.tar.bz2"
LANGTOOLS_TARBALL="9cf0f33fe118.tar.bz2"
OPENJDK_TARBALL="b7da16493c1b.tar.bz2"

CACAO_TARBALL="cacao-c182f119eaad.tar.gz"
JAMVM_TARBALL="jamvm-ec18fb9e49e62dce16c5094ef1527eed619463aa.tar.gz"

CORBA_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-corba-${CORBA_TARBALL}"
JAXP_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxp-${JAXP_TARBALL}"
JAXWS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxws-${JAXWS_TARBALL}"
JDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jdk-${JDK_TARBALL}"
LANGTOOLS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-langtools-${LANGTOOLS_TARBALL}"
OPENJDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-openjdk-${OPENJDK_TARBALL}"
HOTSPOT_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-hotspot-${HOTSPOT_TARBALL}"

CACAO_GENTOO_TARBALL="icedtea-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${JAMVM_TARBALL}"

DROP_URL="https://icedtea.classpath.org/download/drops"
ICEDTEA_URL="${DROP_URL}/icedtea${SLOT}/${ICEDTEA_VER}"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="https://icedtea.classpath.org"
SRC_PKG="${ICEDTEA_PKG}.tar.xz"
SRC_URI="
	https://icedtea.classpath.org/download/source/${SRC_PKG}
	${ICEDTEA_URL}/openjdk.tar.bz2 -> ${OPENJDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/corba.tar.bz2 -> ${CORBA_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxp.tar.bz2 -> ${JAXP_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxws.tar.bz2 -> ${JAXWS_GENTOO_TARBALL}
	${ICEDTEA_URL}/jdk.tar.bz2 -> ${JDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/hotspot.tar.bz2 -> ${HOTSPOT_GENTOO_TARBALL}
	${ICEDTEA_URL}/langtools.tar.bz2 -> ${LANGTOOLS_GENTOO_TARBALL}
	${DROP_URL}/cacao/${CACAO_TARBALL} -> ${CACAO_GENTOO_TARBALL}
	${DROP_URL}/jamvm/${JAMVM_TARBALL} -> ${JAMVM_GENTOO_TARBALL}"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
KEYWORDS="amd64 arm64"

IUSE="+alsa cacao +cups debug doc examples +gtk headless-awt
	jamvm +jbootstrap kerberos libressl nss pax_kernel
	sctp selinux smartcard source test zero"

REQUIRED_USE="gtk? ( !headless-awt )"

# Ideally the following were optional at build time.
ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-1.2.12"
X_COMMON_DEP="
	>=media-libs/giflib-4.1.6:=
	>=media-libs/libpng-1.2:0=
	>=x11-libs/libX11-1.1.3
	>=x11-libs/libXext-1.1.1
	>=x11-libs/libXi-1.1.3
	>=x11-libs/libXrender-0.9.4
	>=x11-libs/libXtst-1.0.3
	x11-libs/libXt
	x11-libs/libXcomposite"
X_DEPEND="
	>=x11-libs/libXau-1.0.3
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXinerama-1.0.2
	x11-base/xorg-proto"

COMMON_DEP="
	app-misc/mime-types
	>=dev-libs/glib-2.26:2
	media-libs/fontconfig
	>=media-libs/freetype-2.10.1:2=
	>=media-libs/lcms-2.5
	>=sys-libs/zlib-1.2.3:=
	virtual/jpeg:0=
	gtk? (
		>=dev-libs/atk-1.30.0
		>=x11-libs/cairo-1.8.8:=
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.8:2=
		>=x11-libs/pango-1.24.5
	)
	kerberos? ( virtual/krb5 )
	nss? ( >=dev-libs/nss-3.12.5-r1 )
	sctp? ( net-misc/lksctp-tools )
	smartcard? ( sys-apps/pcsc-lite )"

# gsettings-desktop-schemas is needed for native proxy support. #431972
RDEPEND="${COMMON_DEP}
	!dev-java/icedtea:0
	!dev-java/icedtea-web:7
	>=gnome-base/gsettings-desktop-schemas-3.12.2
	media-fonts/dejavu
	alsa? ( ${ALSA_COMMON_DEP} )
	cups? ( ${CUPS_COMMON_DEP} )
	!headless-awt? ( ${X_COMMON_DEP} )
	selinux? ( sec-policy/selinux-java )"

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
DEPEND="${COMMON_DEP} ${ALSA_COMMON_DEP} ${CUPS_COMMON_DEP} ${X_COMMON_DEP} ${X_DEPEND}
	|| (
		dev-java/jamvm:2.0-3
		dev-java/icedtea:7
	)
	sys-devel/automake:1.16
	app-arch/cpio
	app-arch/unzip
	app-arch/zip
	app-misc/ca-certificates
	dev-java/ant-core:bootstrap
	dev-lang/perl
	>=dev-libs/libxslt-1.1.26
	!libressl? ( dev-libs/openssl )
	libressl? ( dev-libs/libressl )
	sys-apps/attr
	sys-apps/lsb-release
	virtual/pkgconfig
	pax_kernel? ( sys-apps/elfix )"

S="${WORKDIR}"/${ICEDTEA_PKG}

icedtea_check_requirements() {
	local CHECKREQS_DISK_BUILD

	if use doc; then
		CHECKREQS_DISK_BUILD="9000M"
	else
		CHECKREQS_DISK_BUILD="8500M"
	fi

	check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	icedtea_check_requirements
}

pkg_setup() {
	icedtea_check_requirements

	JAVA_PKG_WANT_BUILD_VM="jamvm-2.0-3	icedtea-7"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${SRC_PKG}

	ln -s "${FILESDIR}/jamvm-1.6.0-aarch64-support.patch" "${S}/patches/jamvm" || die
	ln -s "${FILESDIR}/jamvm-1.6.0-opcode-guard.patch" "${S}/patches/jamvm" || die
	ln -s "${FILESDIR}/${PN}-jdk-musl.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-jdk-no-soname.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-jdk-fix-build.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-jdk-execinfo.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-hotspot-stop-using-obsolete-isnanf.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}${SLOT}-jdk-freetype.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}${SLOT}-hotspot-pointer-comparison.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}${SLOT}-jdk-fcommon.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}${SLOT}-hotspot-miscompile.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-hotspot-musl.patch" "${S}/patches" || die
	ln -s "${FILESDIR}/${PN}-os_linux-remove-glibc-dependencies.patch" "${S}/patches" || die
}

src_prepare() {
	default
	sed -i 's/REQUIRED_FREETYPE_VERSION = 2.2.1/REQUIRED_FREETYPE_VERSION = 2.10.1/' patches/boot/revert-6973616.patch

	#eapply "${FILESDIR}/${PN}${SLOT}-disable-systemtap.patch"
	eautoreconf
}

src_configure() {
	export ANT_HOME="${EPREFIX}/usr/share/ant"

	# For bootstrap builds as the sandbox control file might not yet exist.
	addpredict /proc/self/coredump_filter

	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"

	local cacao_config config hotspot_port jamvm_config use_cacao use_jamvm use_zero zero_config
	local vm=$(java-pkg_get-current-vm)

	# Export patches for configure
	DISTRIBUTION_PATCHES=""

	if use jamvm; then
		DISTRIBUTION_PATCHES+="patches/jamvm/jamvm-1.6.0-aarch64-support.patch "
		DISTRIBUTION_PATCHES+="patches/jamvm/jamvm-1.6.0-opcode-guard.patch "
	fi

	DISTRIBUTION_PATCHES+="patches/${PN}-jdk-musl.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-jdk-no-soname.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-jdk-fix-build.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-jdk-execinfo.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-hotspot-stop-using-obsolete-isnanf.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}${SLOT}-jdk-freetype.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}${SLOT}-jdk-fcommon.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}${SLOT}-hotspot-pointer-comparison.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}${SLOT}-hotspot-miscompile.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-hotspot-musl.patch "
	DISTRIBUTION_PATCHES+="patches/${PN}-os_linux-remove-glibc-dependencies.patch "

	export DISTRIBUTION_PATCHES

	# gcj-jdk ensures ecj is present.
	if use jbootstrap || has "${vm}" jamvm-2.0-3; then
		use jbootstrap || einfo "bootstrap is necessary when building with ${vm}, ignoring USE=\"-jbootstrap\""
		config+=" --enable-bootstrap"
	else
		config+=" --disable-bootstrap"
	fi

	# Use Zero if requested
	if use zero; then
		use_zero="yes"
	fi

	# Use JamVM if requested
	if use jamvm; then
		use_jamvm="yes"
	fi

	# Use CACAO if requested
	if use cacao; then
		use_cacao="yes"
	fi

	# Are we on a architecture with a HotSpot port?
	# In-tree JIT ports are available for amd64, arm, arm64, ppc64 (be&le), SPARC and x86.
	if { use amd64 || use arm || use ppc64 || use sparc || use x86; }; then
		hotspot_port="yes"
	fi

	# Always use HotSpot as the primary VM if available. #389521 #368669 #357633 ...
	# Otherwise use CACAO on ppc and Zero on anything else
	if test "x${hotspot_port}" != "xyes"; then
		if use ppc; then
			use_cacao="yes"
		else
			use_zero="yes"
		fi
	fi

	if test "x${use_jamvm}" = "xyes"; then
		jamvm_config="--enable-jamvm"
	fi

	# Turn on CACAO if needed (non-HS archs) or requested
	if test "x${use_cacao}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling CACAO on an architecture with HotSpot support; issues may result.'
			ewarn 'If so, please rebuild with USE="-cacao"'
		fi
		cacao_config="--enable-cacao"
	fi

	# Turn on Zero if needed (non-HS/CACAO archs) or requested
	if test "x${use_zero}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling Zero on an architecture with HotSpot support; performance will be significantly reduced.'
		fi
		zero_config="--enable-zero"
	fi

	config+=" --with-parallel-jobs=$(makeopts_jobs)"
	config+=" --without-rhino"

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_GENTOO_TARBALL}" \
		--with-corba-src-zip="${DISTDIR}/${CORBA_GENTOO_TARBALL}" \
		--with-jaxp-src-zip="${DISTDIR}/${JAXP_GENTOO_TARBALL}" \
		--with-jaxws-src-zip="${DISTDIR}/${JAXWS_GENTOO_TARBALL}" \
		--with-jdk-src-zip="${DISTDIR}/${JDK_GENTOO_TARBALL}" \
		--with-hotspot-src-zip="${DISTDIR}/${HOTSPOT_GENTOO_TARBALL}" \
		--with-langtools-src-zip="${DISTDIR}/${LANGTOOLS_GENTOO_TARBALL}" \
		--with-cacao-src-zip="${DISTDIR}/${CACAO_GENTOO_TARBALL}" \
		--with-jamvm-src-zip="${DISTDIR}/${JAMVM_GENTOO_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--prefix="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}" \
		--mandir="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}/man" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--with-pkgversion="Gentoo ${PF}" \
		--disable-downloading --disable-Werror --disable-tests \
		--enable-system-lcms --enable-system-jpeg \
		--enable-system-zlib --disable-systemtap-tests \
		--enable-improved-font-rendering \
		$(use_enable !headless-awt system-gif) \
		$(use_enable !headless-awt system-png) \
		$(use_enable !debug optimizations) \
		$(use_enable cups system-cups) \
		$(use_enable doc docs) \
		$(use_enable gtk system-gtk) \
		$(use_enable kerberos system-kerberos) \
		$(use_enable nss) \
		$(use_with pax_kernel pax "${EPREFIX}/usr/sbin/paxmark.sh") \
		$(use_enable sctp system-sctp) \
		$(use_enable smartcard system-pcsc) \
		${zero_config} ${cacao_config} ${jamvm_config}
}

src_compile() {
	# Would use GENTOO_VM otherwise.
	export ANT_RESPECT_JAVA_HOME=TRUE

	# With ant >=1.8.2 all required tasks are part of ant-core
	export ANT_TASKS="none"

	export DISABLE_HOTSPOT_OS_VERSION_CHECK=ok

	emake
}

src_test() {
	# Use Xvfb for tests
	unset DISPLAY

	Xemake check
}

src_install() {
	default

	local dest="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}"
	local ddest="${ED}${dest#/}"

	if ! use alsa; then
		rm -v "${ddest}"/jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	if use headless-awt; then
		rm -vr "${ddest}"/jre/lib/$(get_system_arch)/{xawt,libsplashscreen.*,libjavagtk.*} \
		   "${ddest}"/{,jre/}bin/policytool "${ddest}"/bin/appletviewer || die
	fi

	if ! use examples; then
		rm -r "${ddest}"/demo "${ddest}"/sample || die
	fi

	if ! use source; then
		rm -v "${ddest}"/src.zip || die
	fi

	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# We need to generate keystore - bug #273306
	einfo "Generating cacerts file from certificates in ${EPREFIX}/usr/share/ca-certificates/"
	mkdir "${T}/certgen" && cd "${T}/certgen" || die
	cp "${FILESDIR}/generate-cacerts.pl" . && chmod +x generate-cacerts.pl || die
	for c in "${EPREFIX}"/usr/share/ca-certificates/*/*.crt; do
		openssl x509 -text -in "${c}" >> all.crt || die
	done
	./generate-cacerts.pl "${ddest}/bin/keytool" all.crt || die
	cp -vRP cacerts "${ddest}/jre/lib/security/" || die
	chmod 644 "${ddest}/jre/lib/security/cacerts" || die

	java-vm_install-env "${FILESDIR}/icedtea.env.sh"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_preinst() {
	if has_version "<=dev-java/icedtea-7.2.0:7"; then
		# portage would preserve the symlink otherwise, related to bug #384397
		rm -f "${EROOT}/usr/lib/jvm/icedtea7"
		elog "To unify the layout and simplify scripts, the identifier of Icedtea-7*"
		elog "has changed from 'icedtea7' to 'icedtea-7' starting from version 7.2.0-r1"
		elog "If you had icedtea7 as system VM, the change should be automatic, however"
		elog "build VM settings in /etc/java-config-2/build/jdk.conf are not changed"
		elog "and the same holds for any user VM settings. Sorry for the inconvenience."
	fi

	gnome2_icon_savelist;
}

pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
