# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-vi/eselect-vi-1.0.ebuild,v 1.2 2006/09/19 17:42:06 pioto Exp $

DESCRIPTION="Manages the /usr/bin/vi symlink."
HOMEPAGE="http://www.gentoo.org/"


SRC_URI="mirror://gentoo/vi.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/vi.eselect-${PVR}" vi.eselect
}
