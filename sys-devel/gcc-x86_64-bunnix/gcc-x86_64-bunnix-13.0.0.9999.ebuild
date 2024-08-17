# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit toolchain

EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/gcc"
EGIT_BRANCH="bunnix"

BDEPEND=">=sys-devel/binutils-x86_64-bunnix-2.30"

#if [[ ${CATEGORY} != cross-* ]] ; then
#	# Technically only if USE=hardened *too* right now, but no point in complicating it further.
#	# If GCC is enabling CET by default, we need glibc to be built with support for it.
#	# bug #830454
#	RDEPEND="elibc_glibc? ( sys-libs/glibc[cet(-)?] )"
#	DEPEND="${RDEPEND}"
#	BDEPEND=">=${CATEGORY}/binutils-2.30[cet(-)?]"
#fi

RESTRICT="test"

export CTARGET="x86_64-bunnix"

src_unpack() {
	git-r3_src_unpack

	# Needed for gcc --version to include the upstream commit used
	# rather than only the commit after we apply our patches.
	# It includes both with this.
	echo "${EGIT_VERSION}" > "${S}"/gcc/REVISION || die

	default
}

src_prepare() {
	local p upstreamed_patches=(
		# add them here
	)
	for p in "${upstreamed_patches[@]}"; do
		rm -v "${WORKDIR}/patch/${p}" || die
	done

	toolchain_src_prepare

	eapply_user
}
