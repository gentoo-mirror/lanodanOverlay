# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="GStreamer plugin for ICE (RFC 5245) support"
HOMEPAGE="https://nice.freedesktop.org/"

SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

S="${WORKDIR}"

RDEPEND="~net-libs/libnice-${PV}[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
