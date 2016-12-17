# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Library and tools to access FileVault Drive Encryption (FVDE) encrypted volumes"
HOMEPAGE="https://github.com/libyal/libfvde"
SRC_URI="https://github.com/libyal/${PN}/releases/download/${PV}/${PN}-experimental-${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug hfs python"

DEPEND="
	hfs? ( sys-fs/hfsutils )
	sys-fs/fuse"
RDEPEND="${DEPEND}"

src_configure() {
    econf \
        $(use_enable python ) \
        $(use_enable debug debug-output ) \
        $(use_enable debug verbose-output )
}
