#Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit eutils mercurial cmake-utils

DESCRIPTION="1Password-compatible password management tool"
HOMEPAGE="https://icculus.org/${PN}/"
SRC_URI=""

EHG_REPO_URI="http://hg.icculus.org/icculus/${PN}/"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
x11-libs/gtk+:2
x11-libs/libXtst"

src_prepare()
{
	# Fix basedir so that it actually finds our Dropbox-synced keychain...
	sed -e 's#local basedir = "#local basedir = "/home/bpinto/#' -i 1pass.lua || die
	# Fix lua calls so that we can install the scripts in a sane place...
	sed -re "s#(1pass.lua)#/usr/lib/${PN}/\1#g" -i 1pass.c || die
	sed -re "s#(JSON.lua)#/usr/lib/${PN}/\1#g" -i 1pass.lua || die
	sed -re "s#(dumptable.lua)#/usr/lib/${PN}/\1#g" -i 1pass.lua || die
	# Disable credit card (parser problem)
	sed -re 's#local expiredate =.*#local expiredate = nil#' -i 1pass.lua || die
}

# No install target
src_install()
{
	dobin ${BUILD_DIR}/1pass
	# Install the scripts in a sane location...
	dodir /usr/lib/${PN}
	insinto /usr/lib/${PN}
	doins 1pass.lua
	doins JSON.lua
	doins dumptable.lua
}
