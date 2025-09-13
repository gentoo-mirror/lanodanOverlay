# Copyright 2024-2025 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

EGIT_COMMIT="3c040368f6791553610e362401db1efff4b4c5b8"

DESCRIPTION="Implementation of the SSL/TLS protocol in C"
HOMEPAGE="https://bearssl.org/"
SRC_URI="https://bearssl.org/gitweb/?p=BearSSL;a=snapshot;h=${EGIT_COMMIT};sf=tgz -> BearSSL-${EGIT_COMMIT}.tar.gz"
LICENSE="MIT"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64"

S="${WORKDIR}/BearSSL-${EGIT_COMMIT:0:7}/"

IUSE="static-libs"

src_prepare() {
	default

	rm T0Comp.exe || die
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" CFLAGS="$CFLAGS" \
		LD="$(tc-getCC)" LDFLAGS="$LDFLAGS" \
		LDDLL="$(tc-getCC)" LDDLLFLAGS="$CFLAGS $LDFLAGS -shared -Wl,-soname,libbearssl.so.${PV%%.*}" \
		D=".so.$PV"
}

src_test() {
	cd "${S}/build" || die
	./testx509 || die
	./testcrypto all || die
}

src_install() {
	libdir="${ED}/usr/$(get_libdir)/"

	dobin build/brssl

	doheader -r inc/*

	mkdir -p "$libdir" || die
	cp -f build/libbearssl.so.$PV "$libdir/" || die
	ln -s libbearssl.so.$PV "$libdir/libbearssl.so.${PV%%.*}" || die
	ln -s libbearssl.so.$PV "$libdir/libbearssl.so" || die
	if use static-libs; then
		cp -f build/libbearssl.a "$libdir/" || die
	fi

	mkdir -p "$libdir/pkgconfig/" || die
	sed \
		-e "s;@PREFIX@;${EPREFIX}/usr;" \
		-e "s;@VERSION@;${PV%%_*};" \
		"${FILESDIR}/bearssl.pc.in" > "${libdir}/pkgconfig/bearssl.pc" || die
}
