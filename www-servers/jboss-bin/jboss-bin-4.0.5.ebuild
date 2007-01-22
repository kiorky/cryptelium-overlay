# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/jboss/jboss-3.2.5.ebuild,v 1.11 2006/09/20 11:29:31 caster Exp $

inherit eutils java-pkg-2

MY_P="jboss-${PV}"
MY_P="${MY_P}.GA"
MY_EJB3="jboss-EJB-3.0_RC9_Patch_1"

DESCRIPTION="An open source, standards-compliant, J2EE-based application server implemented in 100% Pure Java."
SRC_URI="mirror://sourceforge/jboss/${MY_P}.zip
		 ejb3? ( mirror://sourceforge/jboss/${MY_EJB3}.zip )"
RESTRICT="nomirror"
HOMEPAGE="http://www.jboss.org"
LICENSE="LGPL-2"
IUSE="doc ejb3 srvdir"
SLOT="4"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.4"
DEPEND="${RDEPEND} 	app-arch/unzip"

S=${WORKDIR}/${MY_P}
INSTALL_DIR="/opt/${PN}-${SLOT}"
CACHE_INSTALL_DIR="/var/cache/${PN}-${SLOT}"
LOG_INSTALL_DIR="/var/log/${PN}-${SLOT}"
RUN_INSTALL_DIR="/var/run/${PN}-${SLOT}"
TMP_INSTALL_DIR="/var/tmp/${PN}-${SLOT}"
CONF_INSTALL_DIR="/etc/${PN}-${SLOT}"


# NOTE: When you are updating CONFIG_PROTECT env.d file, you can use this script on your current install
# run from /var/lib/jboss-${SLOT} to get list of files that should be config protected. We protect *.xml,
# *.properties and *.tld files.
# SLOT="4" TEST=`find /var/lib/jboss-${SLOT}/ -type f | grep -E -e "\.(xml|properties|tld)$"`; echo $TEST

src_install() {

	# add optionnal jboss EJB 3.0 implementation
	if use ejb3;then
		einfo "Activation ejb 3.0 support"
		cwd="$(pwd)"
		local libdir="$MY_P/server/all/lib"
		local deploy="$MY_P/server/all/deploy"
		rm -rf ${libdir}/ejb3-persistence.jar\
			  ${libdir}/hibernate-annotations.jar\
			  ${libdir}/hibernate3.jar\
			  ${libdir}/hibernate-entitymanager.jar\
			  ${deploy}/jboss-aop.deployer
		cp -rf $MY_EJB3/lib/ejb3.deployer\
		       $MY_EJB3/lib/jboss-aop-jdk50.deployer\
			   $MY_EJB3/lib/ejb3-clustered-sfsbcache-service.xml\
			   $MY_EJB3/lib/ejb3-entity-cache-service.xml\
			   $MY_EJB3/lib/ejb3-interceptors-aop.xml\
			   ${deploy}
		local libdir="$MY_P/server/default/lib"
		local deploy="$MY_P/server/default/deploy"
		rm -rf ${libdir}/ejb3-persistence.jar\
			  ${libdir}/hibernate-annotations.jar\
			  ${libdir}/hibernate3.jar\
			  ${libdir}/hibernate-entitymanager.jar\
			  ${deploy}/jboss-aop.deployer
		cp -rf $MY_EJB3/lib/ejb3.deployer\
		       $MY_EJB3/lib/jboss-aop-jdk50.deployer\
			   $MY_EJB3/lib/ejb3-clustered-sfsbcache-service.xml\
			   ${deploy}
	fi

	# copy startup stuff
	doinitd  ${FILESDIR}/${PV}/init.d/${PN}-${SLOT}
	newconfd ${FILESDIR}/${PV}/conf.d/${PN}-${SLOT} ${PN}-${SLOT}
	doenvd   ${FILESDIR}/${PV}/env.d/50${PN}-${SLOT}

	# jboss core stuff
	# create the directory structure and copy the files
	diropts -m755
	dodir ${INSTALL_DIR}        \
		  ${INSTALL_DIR}/bin    \
		  ${INSTALL_DIR}/client \
	      ${INSTALL_DIR}/lib    \
		  ${INSTALL_DIR}/server \
		  ${CACHE_INSTALL_DIR}  \
		  ${CONF_INSTALL_DIR}   \
		  ${LOG_INSTALL_DIR}    \
		  ${RUN_INSTALL_DIR}    \
		  ${TMP_INSTALL_DIR}  
	insopts -m644
	diropts -m755
	insinto ${INSTALL_DIR}/bin
	doins -r bin/*.conf bin/*.jar
	exeinto ${INSTALL_DIR}/bin
	doexe bin/*.sh
	insinto ${INSTALL_DIR}
	doins -r client lib
	
	
	# implement GLEP20: srvdir
	if use srvdir;then
		dodir /srv/localhost/${PN}-${SLOT}
		dosym /srv/localhost/${PN}-${SLOT} server/gentoo
	fi			

	# make a "gentoo" profile
	cp -rf server/default server/gentoo

	for PROFILE in all default $gentoo minimal; do
		# create directory
		diropts -m775
		dodir ${INSTALL_DIR}/server/${PROFILE}/conf   \
		      ${INSTALL_DIR}/server/${PROFILE}/deploy \
		      ${INSTALL_DIR}/server/${PROFILE}/lib   
		# keep stuff
		keepdir     ${CACHE_INSTALL_DIR}/${PROFILE} \
					${LOG_INSTALL_DIR}/${PROFILE}	\
					${TMP_INSTALL_DIR}/${PROFILE}   \
					${RUN_INSTALL_DIR}/${PROFILE}

		# copy files
		insopts -m664
		diropts -m775
		insinto  ${INSTALL_DIR}/server/${PROFILE}/conf
		doins -r server/${PROFILE}/conf/*
		insopts -m664
		diropts -m775
		if [[ $PROFILE != "minimal" ]]; then
			insinto  ${INSTALL_DIR}/server/${PROFILE}/deploy
			doins -r server/${PROFILE}/deploy/*
		else
			dodir  server/${PROFILE}/deploy
		fi
		insopts -m644
		diropts -m755
		insinto  ${INSTALL_DIR}/server/${PROFILE}/lib
		doins -r server/${PROFILE}/lib/*

		# do symlick		
		dosym ${CACHE_INSTALL_DIR}/${PROFILE} ${INSTALL_DIR}/server/${PROFILE}/cache
		dosym ${LOG_INSTALL_DIR}/${PROFILE}   ${INSTALL_DIR}/server/${PROFILE}/log
		dosym ${RUN_INSTALL_DIR}/${PROFILE}   ${INSTALL_DIR}/server/${PROFILE}/work
		dosym ${TMP_INSTALL_DIR}/${PROFILE}   ${INSTALL_DIR}/server//${PROFILE}/tmp
		# for conf file, doing the contrary is trickier
		# keeping the conf file with the whole installation but
		# putting a symlick to /etc/ for easy configuration
		keepdir ${CONF_INSTALL_DIR}/${PROFILE}
		dosym ${INSTALL_DIR}/server/${PROFILE}/conf ${CONF_INSTALL_DIR}/${PROFILE}/conf
		# symlick the tomcat server.xml configuration file
		dosym ${INSTALL_DIR}/server/${PROFILE}/deploy/jbossweb-tomcat55.sar/server.xml	${CONF_INSTALL_DIR}/${PROFILE}/
	done
	
	# we want to keep the minimal webapp
	keepdir ${INSTALL_DIR}/server/minimal/deploy

	# singleton is just on "all" profile
	insinto ${INSTALL_DIR}/server/all
	doins -r server/all/deploy-hasingleton server/all/farm

	# write access is set for jboss group so user can use netbeans to start jboss
	# correct access rights
	for dir in ${INSTALL_DIR} ${LOG_INSTALL_DIR} ${TMP_INSTALL_DIR} ${CACHE_INSTALL_DIR} ${RUN_INSTALL_DIR}; do
		fowners -R jboss:jboss ${dir}
	done

	# the following hack is included until we determine how to make
	# Catalina believe it lives in /var/lib/jboss/$JBOSS_CONF.
	# kiorky: must be resolved now as the build is an monolithical /opt install
	# 21/01/2007                 dosym ${VAR_INSTALL_DIR} ${INSTALL_DIR}/server

	# documentation stuff	
	dodoc copyright.txt
	use doc && dodoc docs/*

}

pkg_setup() {
	enewgroup jboss || die "Unable to create jboss group"
	enewuser jboss -1 /bin/sh /dev/null jboss || die "Unable to create jboss user"
}

pkg_postinst() {
	# fix permissions
	chmod -R g+w ${CACHE_INSTALL_DIR} ${LOG_INSTALL_DIR} ${TMP_INSTALL_DIR} ${RUN_INSTALL_DIR}
	chown -R jboss:jboss ${CACHE_INSTALL_DIR} ${LOG_INSTALL_DIR} ${TMP_INSTALL_DIR} ${RUN_INSTALL_DIR}

	einfo
	einfo " If you want to run multiple instances of JBoss, you can do that this way:"
	einfo " 1) symlink init script:"
	einfo "    ln -s /etc/init.d/${PN}-${SLOT} /etc/init.d/${PN}-${SLOT}.foo"
	einfo " 2) copy original config file:"
	einfo "    cp /etc/conf.d/${PN}-${SLOT} /etc/conf.d/${PN}-${SLOT}.foo"
	einfo " 3) edit the new config file so it uses another JBOSS_SERVER_NAME, eventually"
	einfo "    create new server directories if you do not set one of the predefined"
	einfo "    server names like default, all or minimal and set up the new JBoss"
	einfo "    (you have to either bind new JBoss instance to another IP address or change"
	einfo "    used ports so they do not conflict)"
	einfo " 4) run the new JBoss instance:"
	einfo "    /etc/init.d/${PN}-${SLOT}.foo start"
	einfo
	einfo " If you want to run JBoss from Netbeans, add your user to 'jboss' group."
	einfo
}
