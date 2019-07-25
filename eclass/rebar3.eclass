# Copyright 1999-2016 Gentoo Foundation
# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rebar3.eclass
# @MAINTAINER:
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# @AUTHOR:
# Amadeusz Żołnowski <aidecoe@gentoo.org>
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# @SUPPORTED_EAPIS: 6
# @BLURB: Build Erlang/OTP projects using dev-util/rebar3.
# @DESCRIPTION:
# An eclass providing functions to build Erlang/OTP projects using
# dev-util/rebar:3.
#
# rebar3 is a tool which tries to resolve dependencies itself which is by
# cloning remote git repositories. Dependant projects are usually expected to
# be in sub-directory 'deps' rather than looking at system Erlang lib
# directory. Projects relying on rebar3 usually don't have 'install' make
# targets. The eclass workarounds some of these problems. It handles
# installation in a generic way for Erlang/OTP structured projects.

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_prepare src_compile src_test src_install

RDEPEND="dev-lang/erlang"
DEPEND="
	${RDEPEND}
	dev-util/rebar:3
"

# @ECLASS-VARIABLE: REBAR3_APP_SRC
# @DESCRIPTION:
# Relative path to .app.src description file.
REBAR3_APP_SRC="${REBAR3_APP_SRC-src/${PN}.app.src}"

# @FUNCTION: get_erl_libs
# @RETURN: the path to Erlang lib directory
# @DESCRIPTION:
# Get the full path without EPREFIX to Erlang lib directory.
get_erl_libs() {
	echo "/usr/$(get_libdir)/erlang/lib"
}

# @FUNCTION: _rebar3_find_dep
# @INTERNAL
# @USAGE: <project_name>
# @RETURN: full path with EPREFIX to a Erlang package/project on success,
# code 1 when dependency is not found and code 2 if multiple versions of
# dependency are found.
# @DESCRIPTION:
# Find a Erlang package/project by name in Erlang lib directory. Project
# directory is usually suffixed with version. It is matched to '<project_name>'
# or '<project_name>-*'.
_rebar3_find_dep() {
	local pn="$1"
	local p
	local result

	pushd "${EPREFIX}$(get_erl_libs)" >/dev/null || return 1
	for p in ${pn} ${pn}-*; do
		if [[ -d ${p} ]]; then
			# Ensure there's at most one matching.
			[[ ${result} ]] && return 2
			result="${p}"
		fi
	done
	popd >/dev/null || die

	[[ ${result} ]] || return 1
	echo "${result}"
}

# @FUNCTION: rebar3_disable_coverage
# @USAGE: [<rebar3_config>]
# @DESCRIPTION:
# Disable coverage in rebar3.config. This is a workaround for failing coverage.
# Coverage is not relevant in this context, so there's no harm to disable it,
# although the issue should be fixed.
rebar3_disable_coverage() {
	debug-print-function ${FUNCNAME} "${@}"

	local rebar3_config="${1:-rebar3.config}"

	sed -e 's/{cover_enabled, true}/{cover_enabled, false}/' \
		-i "${rebar3_config}" \
		|| die "failed to disable coverage in ${rebar3_config}"
}

# @FUNCTION: erebar3
# @USAGE: <targets>
# @DESCRIPTION:
# Run rebar3 with verbose flag. Die on failure.
erebar3() {
	debug-print-function ${FUNCNAME} "${@}"

	(( $# > 0 )) || die "erebar3: at least one target is required"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	# XXX: Look at why "-v skip_deps=true" argument needed to be removed
	rebar3 "$@" || die -n "rebar3 $@ failed"
}

# @FUNCTION: rebar3_fix_include_path
# @USAGE: <project_name> [<rebar3_config>]
# @DESCRIPTION:
# Fix path in rebar3.config to 'include' directory of dependant project/package,
# so it points to installation in system Erlang lib rather than relative 'deps'
# directory.
#
# <rebar3_config> is optional. Default is 'rebar3.config'.
#
# The function dies on failure.
rebar3_fix_include_path() {
	debug-print-function ${FUNCNAME} "${@}"

	local pn="$1"
	local rebar3_config="${2:-rebar3.config}"
	local erl_libs="${EPREFIX}$(get_erl_libs)"
	local p

	p="$(_rebar3_find_dep "${pn}")" \
		|| die "failed to unambiguously resolve dependency of '${pn}'"

	gawk -i inplace \
		-v erl_libs="${erl_libs}" -v pn="${pn}" -v p="${p}" '
/^{[[:space:]]*erl_opts[[:space:]]*,/, /}[[:space:]]*\.$/ {
	pattern = "\"(./)?deps/" pn "/include\"";
	if (match($0, "{i,[[:space:]]*" pattern "[[:space:]]*}")) {
		sub(pattern, "\"" erl_libs "/" p "/include\"");
	}
	print $0;
	next;
}
1
' "${rebar3_config}" || die "failed to fix include paths in ${rebar3_config} for '${pn}'"
}

# @FUNCTION: rebar3_remove_deps
# @USAGE: [<rebar3_config>]
# @DESCRIPTION:
# Remove dependencies list from rebar3.config and deceive build rules that any
# dependencies are already fetched and built. Otherwise rebar3 tries to fetch
# dependencies and compile them.
#
# <rebar3_config> is optional. Default is 'rebar3.config'.
#
# The function dies on failure.
rebar3_remove_deps() {
	debug-print-function ${FUNCNAME} "${@}"

	local rebar3_config="${1:-rebar3.config}"

	mkdir -p "${S}/deps" && :>"${S}/deps/.got" && :>"${S}/deps/.built" || die
	gawk -i inplace '
/^{[[:space:]]*deps[[:space:]]*,/, /}[[:space:]]*\.$/ {
	if ($0 ~ /}[[:space:]]*\.$/) {
		print "{deps, []}.";
	}
	next;
}
1
' "${rebar3_config}" || die "failed to remove deps from ${rebar3_config}"
}

# @FUNCTION: rebar3_set_vsn
# @USAGE: [<version>]
# @DESCRIPTION:
# Set version in project description file if it's not set.
#
# <version> is optional. Default is PV stripped from version suffix.
#
# The function dies on failure.
rebar3_set_vsn() {
	debug-print-function ${FUNCNAME} "${@}"

	local version="${1:-${PV%_*}}"

	if [ -f "${S}/${REBAR3_APP_SRC}" ]; then
		sed -e "s/vsn, git/vsn, \"${version}\"/" \
			-i "${S}/${REBAR3_APP_SRC}" \
			|| die "failed to set version in ${S}/${REBAR3_APP_SRC}"
	fi
}

# @FUNCTION: rebar3_src_prepare
# @DESCRIPTION:
# Prevent rebar3 from fetching and compiling dependencies. Set version in
# project description file if it's not set.
#
# Existence of rebar3.config is optional, but file description file must exist
# at 'src/${PN}.app.src'.
rebar3_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	rebar3_set_vsn
	if [[ -f rebar3.config ]]; then
		rebar3_disable_coverage
		rebar3_remove_deps
	fi
}

# @FUNCTION: rebar3_src_configure
# @DESCRIPTION:
# Configure with ERL_LIBS set.
rebar3_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x ERL_LIBS="${EPREFIX}$(get_erl_libs)"
	default
}

# @FUNCTION: rebar3_src_compile
# @DESCRIPTION:
# Compile project with rebar3.
rebar3_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar3 compile
}

# @FUNCTION: rebar3_src_test
# @DESCRIPTION:
# Run unit tests.
rebar3_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	erebar3 eunit
}

# @FUNCTION: rebar3_src_install
# @DESCRIPTION:
# Install BEAM files, include headers, executables and native libraries.
# Install standard docs like README or defined in DOCS variable.
#
# Function expects that project conforms to Erlang/OTP structure.
rebar3_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local bin
	local dest="$(get_erl_libs)/${P}"

	insinto "${dest}"
	pushd "_build/default/lib/${PN}" >/dev/null
	doins -r ebin
	popd >/dev/null
	[[ -d include ]] && doins -r include
	[[ -d bin ]] && for bin in bin/*; do dobin "$bin"; done

	if [[ -d priv ]]; then
		cp -pR priv "${ED}${dest}/" || die "failed to install priv/"
	fi

	einstalldocs
}
