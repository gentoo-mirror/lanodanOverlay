# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HOMEPAGE="https://public-inbox.org/"
SRC_URI="https://public-inbox.org/releases/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xapian gzip nntp inbox_watch daemon"

DEPEND="
	dev-vcs/git
	dev-lang/perl
	dev-db/sqlite
	dev-perl/Time-ParseDate
	dev-perl/Email-MIME
	dev-perl/Email-MIME-ContentType
	dev-perl/Plack
	dev-perl/URI
	xapian? (
		dev-perl/Search-Xapian
	)
	gzip? (
		dev-perl/PerlIO-gzip
		dev-perl/DBI
		dev-perl/DBD-SQLite
	)
	nntp? (
		dev-perl/DBD-SQLite
	)
	inbox_watch? (
		dev-perl/Filesys-Notify-Simple
	)
	daemon? (
		dev-perl/Inline-C
	)
"

src_prepare() {
	default

	perl Makefile.PL || die
}
