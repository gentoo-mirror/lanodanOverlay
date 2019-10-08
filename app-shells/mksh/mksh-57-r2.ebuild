# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

if [[ $PV = 9999 ]]; then
	inherit cvs
	ECVS_SERVER="anoncvs.mirbsd.org:/cvs"
	ECVS_MODULE="mksh"
	ECVS_USER="_anoncvs"
	ECVS_AUTH="ext"
	KEYWORDS=""
else
	SRC_URI="https://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.tgz"
	KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MirBSD Korn Shell"
HOMEPAGE="http://mirbsd.de/mksh"
LICENSE="BSD"
SLOT="0"
IUSE="static +lksh"
S="${WORKDIR}/${PN}"

src_prepare() {
	default

	if use lksh; then
		cp "${S}" "${S}"_lksh
	fi
}

src_compile() {
	tc-export CC
	if use static; then
		export LDSTATIC="-static"
	fi

	export CPPFLAGS="${CPPFLAGS} -DMKSH_DEFAULT_PROFILEDIR=\\\"${EPREFIX}/etc\\\""

	# TODO: Add lksh to `/etc/shells (sys-apps/baselayout)` and `app-eselect/eselect-sh`
	if use lksh; then
		cd "${S}"_lksh
		CPPFLAGS="${CPPFLAGS} -DMKSH_BINSHPOSIX -DMKSH_BINSHREDUCED" \
			sh Build.sh -r -L || die
	fi

	sh Build.sh -r || die
}

src_install() {
	exeinto /bin
	doexe mksh
	doman mksh.1
	dodoc dot.mkshrc

	if use lksh; then
		cd "${S}"_lksh

		doexe lksh
		doman lksh.1
	fi
}

src_test() {
	./test.sh -v || die

	if use lksh; then
		cd "${S}"_lksh
		./test.sh -v || die
	fi
}
