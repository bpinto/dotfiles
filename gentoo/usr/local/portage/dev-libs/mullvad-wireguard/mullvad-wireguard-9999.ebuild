# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Simple wrapper that makes it easier to use Mullvad's VPN with WireGuard"
HOMEPAGE="https://gitlab.com/adihrustic/Mullvad-WireGuard-Wrapper"

EGIT_REPO_URI="https://gitlab.com/adihrustic/Mullvad-WireGuard-Wrapper.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	return
}

src_install() {
	dobin mullvad
}
