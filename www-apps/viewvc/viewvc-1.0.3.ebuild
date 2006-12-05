# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/viewcvs/viewcvs-1.0_pre20050929.ebuild,v 1.3 2005/10/09 22:17:08 ramereth Exp $

inherit webapp depend.apache eutils python

PS=${P/_/-}
DESCRIPTION="ViewVC, a web interface to cvs and subversion"
HOMEPAGE="http://viewvc.org/"
SRC_URI="http://viewvc.tigris.org/files/documents/3330/34803/${PS}.tar.gz"

LICENSE="viewcvs"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="cvsgraph enscript highlight mod_python mysql"

want_apache

RDEPEND="|| ( >=dev-util/cvs-1.11
              dev-util/cvsnt
			  dev-util/subversion )
		dev-lang/python
		|| ( >=app-text/rcs-5.7
			dev-util/cvsnt )
		sys-apps/diffutils
		cvsgraph? ( dev-util/cvsgraph )
		enscript? ( app-text/enscript )
		highlight? ( app-text/highlight )
		apache2? ( mod_python? ( dev-python/mod_python ) )
		mysql? ( dev-db/mysql
				 dev-python/mysql-python )
		!apache? ( !apache2? ( www-servers/lighttpd ) )"

S=${WORKDIR}/${PS}

pkg_setup() {
	if has_version dev-util/subversion && ! built_with_use dev-util/subversion python ; then
		eerror "Your subversion has been built without python bindings"
		eerror "If you want subversion to work with viewvc, please"
		eerror "enable the 'python' useflag"
		die "pkg_setup failed"
	fi
	if use mod_python && ! use apache2 ; then
		eerror "mod_python requires at least apache2"
		die "pkg_setup failed"
	fi
	webapp_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_install() {
	webapp_src_preinst
	dodir ${MY_CGIBINDIR}/${PN} ${MY_HOSTROOTDIR}/${PN}

	exeinto ${MY_CGIBINDIR}/${PN}
	doexe bin/cgi/viewvc.cgi

	if use mysql ; then
		exeinto ${MY_CGIBINDIR}/${PN}
		doexe bin/cgi/query.cgi
	fi

	if use mod_python && use apache2 ; then
		insinto ${MY_HTDOCSDIR}
		doins bin/mod_python/viewvc.py
		if use mysql ; then
			insinto ${MY_HTDOCSDIR}
			doins bin/mod_python/query.py
		fi
		insinto ${MY_HTDOCSDIR}
		doins bin/mod_python/.htaccess
		doins bin/mod_python/handler.py
	fi

	cp -rp bin/ ${D}/${MY_HOSTROOTDIR}/${PN}/
	cp -rp lib/ ${D}/${MY_HOSTROOTDIR}/${PN}/
	cp -rp templates/ ${D}/${MY_HOSTROOTDIR}/${PN}/
	insinto ${MY_HOSTROOTDIR}/${PN}
	newins viewvc.conf.dist viewvc.conf.example
	newins cvsgraph.conf.dist cvsgraph.conf.example

	dosym /usr/share/doc/${PF}/html ${MY_HTDOCSDIR}/doc
	dodoc CHANGES COMMITTERS INSTALL README TODO
	dohtml -r viewvc.org/*

	webapp_configfile ${MY_HOSTROOTDIR}/${PN}/viewvc.conf.example
	webapp_configfile ${MY_HOSTROOTDIR}/${PN}/cvsgraph.conf.example
	webapp_postinst_txt en ${FILESDIR}/postinstall-new-en.txt
	webapp_hook_script ${FILESDIR}/reconfig

	if use mysql && has_version "=dev-db/mysql-4.0*" ; then
		webapp_sqlscript mysql ${FILESDIR}/viewcvs-mysql-4.0.sql
	elif use mysql && has_version "=dev-db/mysql-4.1*" ; then
		webapp_sqlscript mysql ${FILESDIR}/viewcvs-mysql-4.1.sql
	fi

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
	python_mod_optimize ${MY_HOSTROOTDIR}/${PN}/lib
}

pkg_postrm() {
	python_mod_cleanup
}
