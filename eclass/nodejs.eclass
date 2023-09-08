# Copyright 2022 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nodejs.eclass
# @MAINTAINER:
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# @AUTHOR:
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Build NodeJS projects
# @DESCRIPTION:
# An eclass providing functions to build NodeJS projects

case "${EAPI:-0}" in
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_test

BDEPEND="
	net-libs/nodejs
	app-misc/jq
"
RDEPEND="dev-nodejs/node_path"

NODEJS_SITELIB="/usr/share/nodejs/"

nodejs_src_test() {
	if jq -e '.scripts | has("test")' <package.json >/dev/null
	then
		# --ignore-scripts: do not run pretest and posttest
		npm test --ignore-scripts || die
	else
		die 'No "test" command defined in package.json'
	fi
}
