# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GNOME Development Library"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.0
		 >=x11-libs/gtk+-2.3.0
		 >=gnome-base/orbit-2.2.0
		 >=gnome-base/libglade-2
		 >=gnome-base/libbonobo-2
		 >=gnome-base/libbonoboui-2.2.0
		 >=dev-libs/libxml2-2.2.8"
DEPEND="${RDEPEND}
		dev-lang/perl
		dev-perl/XML-Parser
		sys-devel/gettext
		dev-util/pkgconfig
		doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR=1
