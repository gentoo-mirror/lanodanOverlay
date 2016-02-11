# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for editor"
SLOT="0"
KEYWORDS=""

# Add a package to RDEPEND only if the editor:
# - can edit ordinary text files,
# - works on the console. // Wut? xemacs and gvim doesn’t works in a terminal

RDEPEND="|| ( app-editors/nano
	app-editors/dav
	app-editors/e3
	app-editors/ee
	app-editors/efte
	app-editors/elvis
	app-editors/emacs
	app-editors/emacs-vcs
	app-editors/emact
	app-editors/ersatz-emacs
	app-editors/fe
	app-editors/jasspa-microemacs
	app-editors/jed
	app-editors/joe
	app-editors/jove
	app-editors/le
	app-editors/levee
	app-editors/lpe
	app-editors/mg
	app-editors/ne
	app-editors/neovim
	app-editors/ng
	app-editors/nvi
	app-editors/qemacs
	app-editors/teco
	app-editors/uemacs-pk
	app-editors/vile
	app-editors/vim
	app-editors/vis
	app-editors/gvim
	app-editors/xemacs
	app-editors/zile
	app-misc/mc[edit]
	dev-lisp/cmucl
	mail-client/alpine[-onlyalpine]
	sys-apps/ed )"

# Packages outside app-editors providing an editor:
#	app-misc/mc: mcedit (#62643)
#	dev-lisp/cmucl: hemlock
#	mail-client/alpine: pico
#	sys-apps/busybox: vi
#	sys-apps/9base: ed // @Note: sam needs samterm(where is it?) and don’t know how to use ssam