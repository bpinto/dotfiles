# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="5"

inherit linux-mod git-r3

SLOT="0"

DESCRIPTION="Macbook Air 6,x backlight fix"
HOMEPAGE="https://github.com/patjak/mba6x_bl"
#SRC_URI="https://github.com/patjak/mba6x_bl.git"

EGIT_REPO_URI="git://github.com/patjak/${PN}.git"

LICENSE="GPL-2"
KEYWORDS=""

BUILD_TARGETS="clean all"
MODULE_NAMES="mba6x_bl(misc)"

src_unpack() {
  git-r3_src_unpack
}

src_install() {
  linux-mod_src_install
}

pkg_postinst() {
  linux-mod_pkg_postinst
}
