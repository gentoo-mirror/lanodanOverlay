# Copyright 2022-2023 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
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

# https://docs.npmjs.com/cli/v6/configuring-npm/package-json/

case "${EAPI:-0}" in
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_compile src_test src_install

BDEPEND="
	net-libs/nodejs
	app-misc/jq
	sys-apps/cmd-glob
"
RDEPEND="dev-nodejs/node_path"

NODEJS_SITELIB="/usr/share/nodejs/"

NPM_FLAGS=(
	--audit false
	--offline
	--verbose
)

enpm() {
	debug-print-function ${FUNCNAME} "$@"

	set -- npm "${NPM_FLAGS[@]}" "$@"
	echo "$@" >&2
	"$@" || die
}

nodejs_src_test() {
	if jq -e '.scripts | has("test")' <package.json >/dev/null
	then
		# --ignore-scripts: do not run pretest and posttest
		enpm run test --ignore-scripts
	else
		die 'No "test" command defined in package.json'
	fi
}

nodejs_src_compile() {
	# https://docs.npmjs.com/cli/v10/configuring-npm/package-json/#default-values
	if jq -e '.scripts | has("install")' <package.json >/dev/null
	then
		if jq -e '.scripts | has("preinstall")' <package.json >/dev/null
		then
			enpm run preinstall
		fi

		npm "${NPM_FLAGS[@]}" run install || die

		if jq -e '.scripts | has("postinstall")' <package.json >/dev/null
		then
			enpm run postinstall
		fi
	else
		if test -e binding.gyp; then
			if has_version -b dev-nodejs/node-gyp; then
				node-gyp rebuild || die
			else
				# TODO: Check BDEPEND as QA
				die "binding.gyp found but dev-nodejs/node-gyp is not available as BDEPEND"
			fi
		fi
	fi

	if jq -e '.scripts | has("prepare")' <package.json >/dev/null
	then
		enpm run prepare
	fi
}

# Install files in nodejs hierarchy with preserving path of source files
nodejs_install_path() {
	for file in "$@"; do
		target_dir="${ED}/${NODEJS_MODULE_DIR}/$(dirname "${file}")/"
		mkdir -p "${target_dir}" || die "Failed to create directory for ${file}"
		cp -r "${file}" "${target_dir}" || die "Failed to copy ${file}"
	done
}

nodejs_src_install() {
	einstalldocs

	# https://docs.npmjs.com/cli/v6/configuring-npm/package-json/#files
	if jq -e '.type == "module"' <package.json >/dev/null
	then
		# Assume that everything on NPM is using semver
		NODEJS_MODULE_DIR="${NODEJS_SITELIB}${PN}@$(ver_cut 1)"
		[[ "${SLOT}" != "$(ver_cut 1)" ]] && eqawarn "Got SLOT value ${SLOT} while ES Module would expect $(ver_cut 1)"
	else
		NODEJS_MODULE_DIR="${NODEJS_SITELIB}${PN}"
	fi
	insinto "${NODEJS_MODULE_DIR}"
	doins package.json

	if jq -e 'has("files")' <package.json >/dev/null
	then
		jq -r .files[] <package.json \
		| xargs -d '\n' glob -m \
		| while read file; do
			nodejs_install_path "${file}"
		done
	else
		doins -r .
	fi

	if jq -e 'has("main")' <package.json >/dev/null
	then
		main="$(jq -r -e '.main' <package.json)"
		if test -e "${main}"; then
			nodejs_install_path "${main}"
		else
			nodejs_install_path "${main}.js"
		fi
	else
		test -e index.js && nodejs_install_path index.js
	fi

	bin_type="$(jq -r '.bin | type' <package.json)"
	case "${bin_type}" in
		null)
		;;
		object)
			jq -r '.bin | to_entries | .[] | .key + " " + .value' <package.json \
			| while read bin file; do
				nodejs_install_path "${file}"
				fperms 755 "${NODEJS_MODULE_DIR}/${file#./}"
				dosym "${NODEJS_MODULE_DIR}/${file#./}" "/usr/bin/${bin}"
			done
		;;
		string)
			file="$(jq -r '.bin' <package.json)"
			bin="$(basename "${file}")"
			nodejs_install_path "${file}"
			fperms 755 "${NODEJS_MODULE_DIR}/${file#./}"
			dosym "${NODEJS_MODULE_DIR}/${file#./}" "/usr/bin/${bin}"
		;;
		*)
			die "Unhandled package.json#bin type: ${bin_type}"
		;;
	esac
}
