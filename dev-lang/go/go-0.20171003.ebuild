# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

MY_PV="${PV//0./}"

DESCRIPTION="Boostrap Go from C (useful for musl libc)"
HOMEPAGE="https://golang.org/doc/install/source"
SRC_URI="https://dl.google.com/go/go1.4-bootstrap-${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="bootstrap"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

RESTRICT="mirror"

# The go tools should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go1.4/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped. The test data objects should also be left alone and unstripped.
STRIP_MASK="/usr/lib/go1.4/pkg/*.a
	/usr/lib/go1.4/src/debug/elf/testdata/*
	/usr/lib/go1.4/src/debug/dwarf/testdata/*
	/usr/lib/go1.4/src/runtime/race/*.syso
"

S="${WORKDIR}/go"

src_prepare() {
	sed -i -e 's/"-Werror",//g' src/cmd/dist/build.c

	default
}

src_compile() {
	export GOROOT_FINAL="${EPREFIX}/usr/lib/go1.4"
	export GOROOT="$(pwd)"
	export GOBIN="${GOROOT}/bin"
	export CGO_ENABLED=0

	tc-export CC

	cd src
	./make.bash || die "build failed"
}

src_install() {
	dodir /usr/lib/go1.4
	exeinto /usr/lib/go1.4/bin
	doexe bin/*
	insinto /usr/lib/go1.4
	doins -r lib pkg src
	fperms -R +x /usr/lib/go1.4/pkg/tool
}

pkg_postinst() {
	# If the go tool sees a package file timestamped older than a dependancy it
	# will rebuild that file.  So, in order to stop go from rebuilding lots of
	# packages for every build we need to fix the timestamps.  The compiler and
	# linker are also checked - so we need to fix them too.
	ebegin "fixing timestamps to avoid unnecessary rebuilds"
	tref="usr/lib/go1.4/pkg/*/runtime.a"
	find "${EROOT}"usr/lib/go1.4 -type f \
		-exec touch -r "${EROOT}"${tref} {} \;
	eend $?
}
