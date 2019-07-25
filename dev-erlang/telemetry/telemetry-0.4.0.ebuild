# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Dynamic dispatching library for metrics and instrumentations."
HOMEPAGE="https://github.com/beam-telemetry/telemetry"
LICENSE="Apache-2.0"
SLOT="0"
SRC_URI="https://github.com/beam-telemetry/telemetry/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE=""
