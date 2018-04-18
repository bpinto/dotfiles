# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="Dynamic menu library and client program inspired by dmenu"
HOMEPAGE="https://github.com/Cloudef/bemenu"

EGIT_REPO_URI="https://github.com/Cloudef/bemenu.git"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ncurses wayland X"

DEPEND="
	x11-libs/cairo
	x11-libs/pango
	ncurses? ( sys-libs/ncurses )
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	X? ( x11-libs/libXinerama )
"

RDEPEND="${DEPEND}"
