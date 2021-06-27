# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual ebuild for ::gentoo compatibility"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtk-doc"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390  ~sparc ~x86  ~x64-cygwin   ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos   ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-util/gtk-doc"
RESTRICT="test"
S="${WORKDIR}"

src_compile() {
	:
}

src_install() {
	:
}
