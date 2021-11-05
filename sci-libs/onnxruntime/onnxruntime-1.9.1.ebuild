# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

CPUINFO_COMMIT=5916273f79a21551890fd3d56fc5375a78d1598d
ONNX_COMMIT=1f63dcb7fcc3a8bf5c3c8e326867ecd6f5c43f35
MP11_COMMIT=21cace4e574180ba64d9307a5e4ea9e5e94d3e8d
OPTIONAL_LITE_COMMIT=4acf4553baa886e10e6613fe1452b706b0250e78
SAFEINT_COMMIT=a104e0cf23be4fe848f7ef1f3e8996fe429b06bb
FLATBUFFERS_PV=1.12.0

DESCRIPTION="cross-platform, high performance ML inferencing and training accelerator"
HOMEPAGE="https://github.com/microsoft/onnxruntime"
SRC_URI="
	https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/pytorch/cpuinfo/archive/${CPUINFO_COMMIT}.tar.gz -> pytorch-cpuinfo-${CPUINFO_COMMIT:0:10}.tar.gz
	https://github.com/onnx/onnx/archive/${ONNX_COMMIT}.tar.gz -> onnx-${ONNX_COMMIT:0:10}.tar.gz
	https://github.com/boostorg/mp11/archive/${MP11_COMMIT}.tar.gz -> boost_mp11-${MP11_COMMIT:0:11}.tar.gz
	https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
	https://github.com/martinmoene/optional-lite/archive/${OPTIONAL_LITE_COMMIT}.tar.gz -> optional-lite-${OPTIONAL_LITE_COMMIT:0:10}.tar.gz
	https://github.com/dcleblanc/SafeInt/archive/${SAFEINT_COMMIT}.tar.gz -> SafeInt-${SAFEINT_COMMIT:0:10}.tar.gz
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="benchmark test"

# libonnxruntime_framework.so: undefined reference to `onnx::AttributeProto_AttributeType_Name[abi:cxx11](onnx::AttributeProto_AttributeType)'
RESTRICT="test"

S="${WORKDIR}/${P}/cmake"

# Needs https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch on eigen-3.4.0
RDEPEND="
	dev-python/numpy
	dev-libs/date:=
	>=dev-libs/boost-1.66:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-libs/flatbuffers:=
	dev-cpp/nlohmann_json:=
	dev-libs/nsync
	dev-cpp/eigen:3
	benchmark? ( dev-cpp/benchmark )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/${P}-system_libs.patch"
)

src_prepare() {
	cmake_src_prepare

	rm -r "${S}/external/pytorch_cpuinfo" || die
	mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}" "${S}/external/pytorch_cpuinfo" || die

	rm -r "${S}/external/onnx" || die
	mv "${WORKDIR}/onnx-${ONNX_COMMIT}" "${S}/external/onnx" || die

	rm -r "${S}/external/mp11" || die
	mv "${WORKDIR}/mp11-${MP11_COMMIT}" "${S}/external/mp11" || die

	rm -r "${S}/external/flatbuffers" || die
	mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}" "${S}/external/flatbuffers" || die

	rm -r "${S}/external/optional-lite" || die
	mv "${WORKDIR}/optional-lite-${OPTIONAL_LITE_COMMIT}" "${S}/external/optional-lite" || die

	rm -r "${S}/external/SafeInt/safeint" || die
	mv "${WORKDIR}/SafeInt-${SAFEINT_COMMIT}" "${S}/external/SafeInt/safeint" || die
}

src_configure() {
	append-cppflags "-I/usr/include/eigen3"

	local mycmakeargs=(
		-Donnxruntime_PREFER_SYSTEM_LIB=ON
		-Donnxruntime_BUILD_BENCHMARKS=$(usex benchmark)
		-Donnxruntime_BUILD_UNIT_TESTS=$(usex test)
	)

	cmake_src_configure
}
