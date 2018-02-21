# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="sources"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="24"

inherit kernel-2
detect_version
detect_arch

HGPV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}.a"
HGPV_URI="https://github.com/copperhead/linux-hardened/releases/download/${HGPV}/linux-hardened-${HGPV}.patch"
SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${DISTDIR}/linux-hardened-${HGPV}.patch:1"
UNIPATCH_EXCLUDE="
	1500_XATTR_USER_PREFIX.patch
	1510_fs-enable-link-security-restrictions-by-default.patch
	2300_enable-poweroff-on-Mac-Pro-11.patch
	2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch
	2600_enable-key-swapping-for-apple-mac.patch
	2900_dev-root-proc-mount-fix.patch"

DESCRIPTION="CopperHead Linux-Hardened kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/"
IUSE=""

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

RDEPEND=">=sys-devel/gcc-4.5"

pkg_postinst() {
	kernel-2_pkg_postinst

	local GRADM_COMPAT="sys-apps/gradm-3.1*"

	ewarn
	ewarn "Users of grsecurity's RBAC system must ensure they are using"
	ewarn "${GRADM_COMPAT}, which is compatible with ${PF}."
	ewarn "It is strongly recommended that the following command is issued"
	ewarn "prior to booting a ${PF} kernel for the first time:"
	ewarn
	ewarn "emerge -na =${GRADM_COMPAT}"
	ewarn
}
