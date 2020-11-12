# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{7,8,9} )

inherit eutils elisp-common gnome2 python-single-r1 readme.gentoo-r1

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtk-doc"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"

IUSE="debug doc emacs pdf test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	dev-libs/libxml2
	app-text/docbook-xsl-stylesheets
	$(python_gen_cond_dep '
		dev-python/pygments[${PYTHON_MULTI_USEDEP}]
	')
	doc? ( app-text/yelp-tools )
	emacs? ( virtual/emacs )
	pdf? (
		|| (
			app-text/dblatex
			dev-java/fop
		)
	)
	test? ( >=dev-libs/glib-2.38.0:2 )
"
DEPEND="${RDEPEND}
	~dev-util/gtk-doc-am-${PV}
	dev-util/itstool
	virtual/pkgconfig
"

pkg_setup() {
	DOC_CONTENTS="gtk-doc does no longer define global key bindings for Emacs.
		You may set your own key bindings for \"gtk-doc-insert\" and
		\"gtk-doc-insert-section\" in your ~/.emacs file."
	SITEFILE=61${PN}-gentoo.el
	python-single-r1_pkg_setup
}

src_prepare() {
	# Remove global Emacs keybindings, bug #184588
	eapply "${FILESDIR}"/${PN}-1.8-emacs-keybindings.patch

	# Apply upstream commit 1baf9a6, bug #646850
	sed -e '1,/exit 1/s/exit 1/exit $1/' \
		-i gtkdoc-mkpdf.in || die

	# Fix dev-libs/glib[gtk-doc] doc generation tests by fixing stuff surrounding deprecations
	# https://gitlab.gnome.org/GNOME/glib/-/merge_requests/1488
	eapply "${FILESDIR}"/${PV}-deprecation-parse-fixes.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable debug)
}

src_compile() {
	gnome2_src_compile
	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	python_fix_shebang "${ED}"/usr/bin/

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		readme.gentoo_create_doc
	fi
}

src_test() {
	emake -j1 check
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use emacs; then
		elisp-site-regen
		readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	use emacs && elisp-site-regen
}
