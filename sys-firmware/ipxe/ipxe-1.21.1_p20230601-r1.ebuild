# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

# for 1.21.1_p20230601
COMMIT_SHA1="4fa4052c7ebb59e4d4aa396f1563c89118623ec7"

DESCRIPTION="Open source network boot (PXE) firmware"
HOMEPAGE="https://ipxe.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_SHA1}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="uefi32 uefi64 ipv6 iso lkrn +qemu undi usb vmware"

BDEPEND="
	app-arch/xz-utils
	dev-lang/perl
	qemu? ( efi64? ( sys-firmware/edk2-tools ) )
	iso? (
		app-cdr/cdrtools
		sys-boot/syslinux
	)
"

src_configure() {
	cat > config/local/general.h <<-EOF || die
		#undef BANNER_TIMEOUT
		#define BANNER_TIMEOUT 0
	EOF

	if use ipv6; then
		cat >> config/local/general.h <<-EOF || die
			#define NET_PROTO_IPV6
		EOF
	fi

	if use vmware; then
		cat >> config/local/general.h <<-EOF || die
			#define VMWARE_SETTINGS
			#define CONSOLE_VMWARE
		EOF
	fi

	restore_config config/local/general.h

	tc-ld-disable-gold
}

ipxemake() {
	# Q='' makes the build verbose since that's what everyone loves now
	emake Q='' \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AS="$(tc-getAS)" \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		RANLIB="$(tc-getRANLIB)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		HOST_CC="$(tc-getBUILD_CC)" \
		"$@"
}

src_compile() {
	# (name, VID, DID) taken from qemu roms/Makefile
	local qemuroms=(
		'e1000    8086 100e'
		'e1000e   8086 10d3'
		'eepro100 8086 1209'
		'ne2k_pci 1050 0940'
		'pcnet    1022 2000'
		'rtl8139  10ec 8139'
		'virtio   1af4 1000'
		'vmxnet3  15ad 07b0'
	)

	export NO_WERROR=1
	if use qemu; then
		for rom in "${qemuroms[@]}"; do
			IFS=' ' read name vid did <<< "${rom}"
			ipxemake CONFIG=qemu bin/"${vid}${did}".rom

			if use efi64; then
				ipxemake CONFIG=qemu bin-x86_64-efi/"${vid}${did}".efidrv

				EfiRom -f "0x${vid}" -i "0x${did}" -l 0x02 \
					-b "bin/${vid}${did}.rom" \
					-ec "bin-x86_64-efi/${vid}${did}.efidrv" \
					-o "bin/efi-${name}.rom" || die
			fi
		done
	fi

	if use vmware; then
		ipxemake bin/8086100f.mrom # e1000
		ipxemake bin/808610d3.mrom # e1000e
		ipxemake bin/10222000.mrom # vlance
		ipxemake bin/15ad07b0.rom # vmxnet3
	fi

	use uefi32 && ipxemake PLATFORM=efi BIN=bin-i386-efi bin-i386-efi/ipxe.efi
	use uefi64 && ipxemake PLATFORM=efi BIN=bin-x86_64-efi bin-x86_64-efi/ipxe.efi
	use iso && ipxemake bin/ipxe.iso
	use undi && ipxemake bin/undionly.kpxe
	use usb && ipxemake bin/ipxe.usb
	use lkrn && ipxemake bin/ipxe.lkrn
}

src_install() {
	insinto /usr/share/ipxe/

	if use qemu || use vmware; then
		doins bin/*.rom
	fi
	use vmware && doins bin/*.mrom
	use uefi32 && newins bin-i386-efi/ipxe.efi ipxe-i386.efi
	use uefi64 && newins bin-x86_64-efi/ipxe.efi ipxe-x86_64.efi
	# Add a symlink for backwards compatiblity, in case both variants are
	# enabled the x86_64 bit variant takes presedence.
	use uefi32 && dosym ipxe-i386.efi /usr/share/ipxe/ipxe.efi
	use uefi64 && dosym ipxe-x86_64.efi /usr/share/ipxe/ipxe.efi

	use iso && doins bin/*.iso
	use undi && doins bin/*.kpxe
	use usb && doins bin/*.usb
	use lkrn && doins bin/*.lkrn

	save_config config/local/general.h
}
