# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Scavenged parts from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=osu-lazer-git

EAPI=6

inherit git-r3

DESCRIPTION="rhythm is just a *click* away!"
HOMEPAGE="https://github.com/ppy/osu"
SRC_URI=""

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

EGIT_REPO_URI="https://github.com/ppy/osu.git"

DEPEND="
	>dev-lang/mono-5.4.0.201
	>dev-dotnet/nuget-4.0.0"
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir -p "osu.Game/bin/Release" || die "Failed creating directory for Release"
	ln -s "/usr/lib/mono/4.5/Facades/netstandard.dll" "osu.Game/bin/Release" || die "Failed symlinking netstandard.dll from mono"
	nuget restore || die "Failed restoring NuGet packages (do you have internet?)"
	default
}

src_compile() {
	export MONO_IOMAP="case"
	xbuild /property:Configuration=Release

	rm "osu.Game/bin/Release/netstandard.dll"
	rm "osu.Desktop/bin/Release/netstandard.dll"
}

src_install() {
	cd "osu.Desktop/bin/Release"

	insinto "/usr/lib/${PN}"

	for binary in *.exe *.dll; do
		doins "$binary"
	done

	doins 'libbass.'*'.so'
	doins 'libbass_fx.'*'.so'
	doins 'libe_sqlite3.so'
}
