# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV="${PV//1.4_p/}"

DESCRIPTION="Boostrap Go from C (useful for musl libc)"
HOMEPAGE="https://golang.org/doc/install/source"
SRC_URI="https://dl.google.com/go/go1.4-bootstrap-${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

# The go tools should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped. The test data objects should also be left alone and unstripped.
STRIP_MASK="/usr/lib/go/pkg/*/*.a
	/usr/lib/go/src/debug/elf/testdata/*
	/usr/lib/go/src/debug/dwarf/testdata/*
	/usr/lib/go/src/runtime/race/*.syso
"

S="${WORKDIR}/go"

DOCS=( AUTHORS CONTRIBUTORS PATENTS README )

src_prepare() {
	sed -i -e 's/"-Werror",//g' src/cmd/dist/build.c || die

	default
}

src_compile() {
	export GOROOT_FINAL="${EPREFIX}/usr/lib/go"
	export GOROOT="$(pwd)"
	export GOBIN="${GOROOT}/bin"
	export CGO_ENABLED=0

	tc-export CC

	cd src
	./make.bash || die "build failed"
}

src_test() {
	cd src
	PATH="${GOBIN}:${PATH}" \
		./run.bash --no-rebuild --banner || die "tests failed"
}

src_install() {
	einstalldocs

	insinto /usr/lib/go
	doins -r doc include lib pkg src
	fperms -R +x /usr/lib/go/pkg/tool

	exeinto /usr/lib/go/bin
	doexe bin/*
}

pkg_postinst() {
	# If the go tool sees a package file timestamped older than a dependancy it
	# will rebuild that file.  So, in order to stop go from rebuilding lots of
	# packages for every build we need to fix the timestamps.  The compiler and
	# linker are also checked - so we need to fix them too.
	ebegin "fixing timestamps to avoid unnecessary rebuilds"
	tref="usr/lib/go/pkg/*/runtime.a"
	find "${EROOT}/usr/lib/go" -type f \
		-exec touch -r "${EROOT}/"${tref} {} \;
	eend $?
}
