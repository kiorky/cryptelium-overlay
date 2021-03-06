# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-vi/eselect-vi-1.1.ebuild,v 1.1 2006/09/24 18:13:46 pioto Exp $

DESCRIPTION="Manages the /usr/bin/vi symlink."
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/vi.eselect-1.1.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">app-admin/eselect-1.0.1"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/vi.eselect-1.1" vi.eselect
}
