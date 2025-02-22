# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=(lua5-4)

inherit cmake flag-o-matic lua-single xdg

if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flyinghead/flycast"
	# 'core/deps/breakpad'
	EGIT_SUBMODULES=( 'core/deps/luabridge' 'core/deps/rcheevos' )
else
	# MINGW_BREAKPAD_COMMIT="1ab24bcc817ebe629bf77daa53529d02361cb1e9"
	LUABRIDGE_COMMIT="fab7b33b896a42dcc865ba5ecdbacd9f40"
	RCHEEVOS_COMMIT="563230b1c249774b4852c944dc7cdcb952c9e8e8"
	VULKAN_ALLOC_COMMIT="6eb62e1515072827db992c2befd80b71b2d04329"
	#	https://github.com/flyinghead/mingw-breakpad/archive/${MINGW_BREAKPAD_COMMIT}.tar.gz -> mingw-breakpad-${MINGW_BREAKPAD_COMMIT}.tar.gz
	SRC_URI="
		https://github.com/flyinghead/flycast/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		lua? ( https://github.com/vinniefalco/LuaBridge/archive/${LUABRIDGE_COMMIT}.tar.gz -> LuaBridge-${LUABRIDGE_COMMIT}.tar.gz )
		https://github.com/RetroAchievements/rcheevos/archive/${RCHEEVOS_COMMIT}.tar.gz -> rcheevos-${RCHEEVOS_COMMIT}.tar.gz
		vulkan? ( https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/archive/${VULKAN_ALLOC_COMMIT}.tar.gz -> VulkanMemoryAllocator-${VULKAN_ALLOC_COMMIT}.tar.gz )
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Sega Dreamcast, Naomi and Atomiswave emulator"
HOMEPAGE="https://github.com/flyinghead/flycast"

LICENSE="GPL-2"
SLOT="0"

IUSE="alsa ao lua opengl +openmp pulseaudio vulkan"

DEPEND="
	dev-libs/libchdr
	dev-libs/libzip
	dev-libs/xxhash
	media-libs/libsdl2
	net-libs/miniupnpc
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	lua? ( ${LUA_DEPS} )
	opengl? ( virtual/opengl )
	openmp? ( sys-devel/gcc:*[openmp] )
	pulseaudio? ( media-libs/libpulse )
	vulkan? (
		>=dev-util/glslang-1.3.231:=
		dev-util/spirv-headers
	)
"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( opengl vulkan ) || ( ao alsa pulseaudio )"

if [[ "${PV}" = 9999* ]]; then
src_unpack() {
	use lua && EGIT_SUBMODULES+=( 'core/deps/luabridge' )
	use vulkan && EGIT_SUBMODULES+=( 'core/deps/VulkanMemoryAllocator' )
	git-r3_src_unpack
}
fi

src_prepare() {
	# Ensure unneeded deps are not bundled
	for dep in chdr dirent glslang libretro-common libzip miniupnpc oboe patches SDL vixl xxHash; do
		rm -rf core/deps/${dep} || die
	done

	if ! [[ "${PV}" = 9999* ]]; then
		rm -fr core/deps/breakpad || die
		#mv "${WORKDIR}/mingw-breakpad-${MINGW_BREAKPAD_COMMIT}" core/deps/breakpad || die

		rm -fr core/deps/luabridge || die
		if use lua; then
			mv "${WORKDIR}/LuaBridge-${LUABRIDGE_COMMIT}" core/deps/luabridge || die
		fi

		rm -fr core/deps/rcheevos || die
		mv "${WORKDIR}/rcheevos-${RCHEEVOS_COMMIT}" core/deps/rcheevos || die

		rm -fr core/deps/VulkanMemoryAllocator || die
		if use vulkan; then
			mv "${WORKDIR}/VulkanMemoryAllocator-${VULKAN_ALLOC_COMMIT}" core/deps/VulkanMemoryAllocator || die
		fi
	fi

	# Skip alsa if flag not enabled
	if use !alsa; then
		sed -i -e '/find_package(ALSA)/d' CMakeLists.txt || die
	fi

	# Skip ao if flag not enabled
	if use !ao; then
		sed -i -e '/pkg_check_modules(AO/d' CMakeLists.txt || die
	fi

	if use lua; then # Lua 5.2 not available in gentoo anymore
		sed -i -e '/find_package(Lua/s/5.2/5.4/' CMakeLists.txt || die
	else # Skip lua if flag not enabled
		sed -i -e '/find_package(Lua/d' CMakeLists.txt || die
	fi

	# Skip pulseaudio if flag not enabled
	if use !pulseaudio; then
		sed -i -e '/pkg_check_modules(LIBPULSE/d' CMakeLists.txt || die
	fi

	# Unbundle xxHash
	sed -i -e '/XXHASH_BUILD_XXHSUM/{N;N;s/.*/target_link_libraries(${PROJECT_NAME} PRIVATE xxhash)/}' \
		CMakeLists.txt || die

	# Unbundle chdr
	sed -i -e '/add_subdirectory.*chdr/d' -e 's/chdr-static/chdr/' \
		-e 's:core/deps/chdr/include:/usr/include/chdr:' CMakeLists.txt || die

	# Do not use ccache
	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt || die

	# Ensure static libs are not built
	sed -i -e '/BUILD_SHARED_LIBS/d' CMakeLists.txt || die

	# Vulkan-header
	sed -i -e '/add_subdirectory(core.*Vulkan-Headers)$/,/Vulkan::Headers/d' \
		-e '/core\/deps\/Vulkan-Headers\/include)/d' CMakeLists.txt || die
	sed -i -e '/ResourceLimits.h/a#include <glslang/Public/ShaderLang.h>' \
		core/rend/vulkan/compiler.cpp || die
	if use vulkan; then
		sed -i -e '$atarget_link_libraries(${PROJECT_NAME} PRIVATE glslang glslang-default-resource-limits)' CMakeLists.txt || die
		if has_version '>=dev-util/glslang-1.3.261'; then
			sed -i -e 's/throwResultException/detail::throwResultException/' core/rend/vulkan/vmallocator.{h,cpp} || die
		fi
		grep -rl 'vk::resultCheck' | xargs sed -i -e 's/vk::resultCheck/vk::detail::resultCheck/g'
		sed -i -e '/end\/transform_matrix.h/a#include <set>' core/rend/vulkan/vulkan_context.cpp || die
	fi

	# Do not use ccache
	sed -i -e '/find_program(CCACHE_PROGRAM ccache)/d' CMakeLists.txt || die

	# Unbundle SDL under linux: (revert crazy commit: #4408aa7)
	sed -i -e '/if(NOT APPLE AND (/s/.*/if( NOT APPLE )/' CMakeLists.txt || die

	# Fix cmake version
	sed -i -e '/cmake_minimum_required/s/2.6.*$/3.20)/' core/deps/xbyak/CMakeLists.txt || die
	sed -i -e 's/3.2/3.20/' core/deps/glm/CMakeLists.txt || die

	append-cxxflags -Wno-unused-result

	# Cleanup mingw-breakpad blobs
	#rm -f \
	#	core/deps/breakpad/src/client/mac/gcov/libgcov.a \
	#	core/deps/breakpad/src/tools/solaris/dump_syms/testdata/dump_syms_regtest.o \
	#	core/deps/breakpad/src/tools/windows/dump_syms/testdata/pe_only_symbol_test.dll \
	#	core/deps/breakpad/src/tools/windows/dump_syms/testdata/dump_syms_regtest64.exe \
	#	core/deps/breakpad/src/tools/windows/binaries/symupload.exe \
	#	core/deps/breakpad/src/tools/windows/binaries/dump_syms.exe || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_BREAKPAD=OFF
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_VULKAN=$(usex vulkan)
		-DUSE_HOST_LIBZIP=ON
		-DUSE_HOST_GLSLANG=ON
		-DUSE_HOST_SDL=ON
		-DWITH_SYSTEM_ZLIB=ON
	)
	cmake_src_configure
}
