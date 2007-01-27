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
IUSE="doc ejb3 "
SLOT="4"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.4	
		ejb3? ( >=virtual/jdk-1.5 )
		"
DEPEND="${RDEPEND} 	
		app-arch/unzip 
		dev-java/ant 
		dev-java/ant-contrib		
		"

S=${WORKDIR}/${MY_P}
INSTALL_DIR="/opt/${PN}-${SLOT}"
CACHE_INSTALL_DIR="/var/cache/${PN}-${SLOT}/localhost"
LOG_INSTALL_DIR="/var/log/${PN}-${SLOT}/localhost"
RUN_INSTALL_DIR="/var/run/${PN}-${SLOT}/localhost"
TMP_INSTALL_DIR="/var/tmp/${PN}-${SLOT}/localhost"
CONF_INSTALL_DIR="/etc/${PN}-${SLOT}/localhost"
SERVICES_DIR="/srv/localhost/${PN}-${SLOT}"


# NOTE: When you are updating CONFIG_PROTECT env.d file, you can use this script on your current install
# run from /var/lib/jboss-${SLOT} to get list of files that should be config protected. We protect *.xml,
# *.properties and *.tld files.
# SLOT="4" TEST=`find /var/lib/jboss-${SLOT}/ -type f | grep -E -e "\.(xml|properties|tld)$"`; echo $TEST
# by kiorky better:
# echo "CONFIG_PROTECT=\"$(find /srv/localhost/jboss-bin-4/ -name "*xml" -or -name \
#          "*properties" -or -name "*tld" |xargs echo -n)\"">>env.d/50jboss-bin-4   

# NOTE: using now GLEP20 as default

src_install() {
	# jboss core stuff
	# create the directory structure and copy the files
	diropts -m750
	dodir ${INSTALL_DIR}        \
		  ${INSTALL_DIR}/bin    \
		  ${INSTALL_DIR}/client \
	      ${INSTALL_DIR}/lib    \
		  ${SERVICES_DIR} \
		  ${CACHE_INSTALL_DIR}  \
		  ${CONF_INSTALL_DIR}   \
		  ${LOG_INSTALL_DIR}    \
		  ${RUN_INSTALL_DIR}    \
		  ${TMP_INSTALL_DIR}  
	insopts -m640
	diropts -m750
	insinto ${INSTALL_DIR}/bin
	doins -r bin/*.conf bin/*.jar
	exeinto ${INSTALL_DIR}/bin
	doexe bin/*.sh
	insinto ${INSTALL_DIR}
	doins -r client lib
		# register runners
	java-pkg_regjar	${D}/${INSTALL_DIR}/bin/*.jar
	#do launch helper scripts which set the good VM to use
	java-pkg_dolauncher jboss-start.sh  \
		--main org.jboss.Main      -into ${INSTALL_DIR}
	java-pkg_dolauncher jboss-stop.sh   \
		--main org.jboss.Shutdown  -into ${INSTALL_DIR}

	# copy startup stuff
	doinitd  ${FILESDIR}/${PV}/init.d/${PN}-${SLOT}
	# add multi instances support (here:localhost)
	dosym /etc/init.d/${PN}-${SLOT} /etc/init.d/${PN}-${SLOT}.localhost
	newconfd ${FILESDIR}/${PV}/conf.d/${PN}-${SLOT} ${PN}-${SLOT}
	# add multi instances support (here:localhost)
	newconfd ${FILESDIR}/${PV}/conf.d/${PN}-${SLOT} ${PN}-${SLOT}.localhost
	doenvd   ${FILESDIR}/${PV}/env.d/50${PN}-${SLOT}
	# jboss profiles creator binary
	exeinto  /usr/bin
	doexe	 ${FILESDIR}/${PV}/bin/jboss-bin-4-profiles-creator.sh
	# implement GLEP20: srvdir
	addpredict ${SERVICES_DIR}
	# add optionnal jboss EJB 3.0 implementation
	if use ejb3;then
		# make a "gentoo" profile with "all" one as a template
		cp -rf server/default    server/gentoo
		einfo "EJB 3.0 support  Activation"
		cd ../$MY_EJB3
		cp -rf ${FILESDIR}/${PV}/ejb3/install.xml .
		JBOSS_HOME="../${MY_P}" ant -f install.xml || die "EJB3 Patch failed"
		einfo "EJB3 installed"
		cd ../${MY_P}
		local backported_jars="jgroups.jar jboss-cache.jar"
		for jar in ${backported_jars};do
			cp -rf server/all/lib/${jar}    server/gentoo/lib
		done
		local backported_apps="jbossws.sar"
		for app in ${backported_apps};do
			cp -rf server/all/deploy/${app}    server/gentoo/deploy
		done
	else
		# make a "gentoo" profile with "default" one as a template
		cp -rf server/default    server/gentoo
	fi
	# our nice little welcome app
	cp -rf ${FILESDIR}/${PV}/tomcat/webapp/ROOT.war server/gentoo/deploy
	# our tomcat configuration to point to our helper
	cp -rf ${FILESDIR}/${PV}/tomcat/server.xml      server/gentoo/deploy/jbossweb-tomcat55.sar/server.xml


	for PROFILE in all default gentoo minimal; do
		# create directory
		diropts -m770
		dodir ${SERVICES_DIR}/${PROFILE}/conf   \
		      ${SERVICES_DIR}/${PROFILE}/deploy \
		      ${SERVICES_DIR}/${PROFILE}/lib   
		# keep stuff
		keepdir     ${CACHE_INSTALL_DIR}/${PROFILE} \
					${CONF_INSTALL_DIR}/${PROFILE}	\
					${LOG_INSTALL_DIR}/${PROFILE}	\
					${TMP_INSTALL_DIR}/${PROFILE}   \
					${RUN_INSTALL_DIR}/${PROFILE}
		if [[ ${PROFILE} != "minimal" ]]; then
			insopts -m660
			diropts -m770
			insinto  ${SERVICES_DIR}/${PROFILE}/deploy
			doins -r server/${PROFILE}/deploy/*
		else
			dodir  ${SERVICES_DIR}/${PROFILE}/deploy
		fi
		# singleton is just on "all" profile
		local clustering="false"
		[[ ${PROFILE} == "all" ]] && clustering="true"
		use "ejb3" && [[ ${PROFILE} == "gentoo" ]] && clustering="true"	
		if [[ $clustering == "true" ]];then
			ewarn "Activating clustering support for profile: ${PROFILE}"
			insopts -m660
			diropts -m770
			dodir    ${SERVICES_DIR}/${PROFILE}/deploy-hasingleton
			insinto  ${SERVICES_DIR}/${PROFILE}/deploy-hasingleton
			doins -r server/all/deploy-hasingleton 
			dodir    ${SERVICES_DIR}/${PROFILE}/farm
			insinto  ${SERVICES_DIR}/${PROFILE}/farm
			doins -r server/all/farm
		fi
		# copy files
		insopts -m664
		diropts -m770
		insinto  ${SERVICES_DIR}/${PROFILE}/conf
		doins -r server/${PROFILE}/conf/*
		insopts -m644
		diropts -m750
		insinto  ${SERVICES_DIR}/${PROFILE}/lib
		doins -r server/${PROFILE}/lib/*
		# do symlick		
		dosym ${CACHE_INSTALL_DIR}/${PROFILE} ${SERVICES_DIR}/${PROFILE}/data
		dosym   ${LOG_INSTALL_DIR}/${PROFILE} ${SERVICES_DIR}/${PROFILE}/log
		dosym   ${TMP_INSTALL_DIR}/${PROFILE} ${SERVICES_DIR}/${PROFILE}/tmp
		dosym   ${RUN_INSTALL_DIR}/${PROFILE} ${SERVICES_DIR}/${PROFILE}/work
		# for conf file, doing the contrary is trickier
		# keeping the conf file with the whole installation but
		# putting a symlick to /etc/ for easy configuration
		dosym ${SERVICES_DIR}/${PROFILE}/conf ${CONF_INSTALL_DIR}/${PROFILE}/conf
		# symlick the tomcat server.xml configuration file
		dosym ${SERVICES_DIR}/${PROFILE}/deploy/jbossweb-tomcat55.sar/server.xml	${CONF_INSTALL_DIR}/${PROFILE}/
	done

	# write access is set for jboss group so user can use netbeans to start jboss
	# correct access rights
	#	if use srvdir;then 
	#	fowners -R jboss:jboss /srv/localhost/${PN}-${SLOT}
	#fi
	# the following hack is included until we determine how to make
	# Catalina believe it lives in /var/lib/jboss/$JBOSS_CONF.
	# kiorky: must be resolved now as the build is an monolithical /opt install
	# 21/01/2007                 dosym ${VAR_INSTALL_DIR} ${INSTALL_DIR}/server

	# documentation stuff	
	insopts -m640
	diropts -m750
	insinto	"/usr/share/doc/${PF}/${DOCDESTTREE}"
	doins copyright.txt
	doins -r docs/*

	# write access is set for jboss group so user can use netbeans to start jboss
	# fix permissions
	local DIR=""
	DIR="${D}/${INSTALL_DIR} ${D}/${LOG_INSTALL_DIR} ${D}/${TMP_INSTALL_DIR}
	${D}/${CACHE_INSTALL_DIR} ${D}/${RUN_INSTALL_DIR} ${D}/${CONF_INSTALL_DIR}
	${D}/${SERVICES_DIR}"
	echo $DIR
	EDIR="${INSTALL_DIR} ${LOG_INSTALL_DIR} ${TMP_INSTALL_DIR}
	${CACHE_INSTALL_DIR} ${RUN_INSTALL_DIR} ${CONF_INSTALL_DIR}
	/srv/localhost/${PN}-${SLOT}"
	echo $EDIR
	chmod -R 765  ${DIR}
	chown -R jboss:jboss ${DIR} 

}

pkg_setup() {
	enewgroup jboss || die "Unable to create jboss group"
	enewuser jboss -1 /bin/sh ${SERVICES_DIR}  jboss || die "Unable to create jboss user"
}

pkg_postinst() {
	elog
	elog " If you want to run multiple instances of JBoss, you can do that this way:"
	elog " 1) symlink init script:"
	elog "    ln -s /etc/init.d/${PN}-${SLOT} /etc/init.d/${PN}-${SLOT}.foo"
	elog " 2) copy original config file:"
	elog "    cp /etc/conf.d/${PN}-${SLOT} /etc/conf.d/${PN}-${SLOT}.foo"
	elog " 3) edit the new config file so it uses another JBOSS_SERVER_NAME, eventually"
	elog "    create new server directories if you do not set one of the predefined"
	elog "    server names like default, all or minimal and set up the new JBoss"
	elog "    (you have to either bind new JBoss instance to another IP address or change"
	elog "    used ports so they do not conflict)"
	elog " 4) run the new JBoss instance:"
	elog "    /etc/init.d/${PN}-${SLOT}.vhost start (eg vhost=localhost"
	elog "             -> ${PN}-${SLOT}.localhost"
	elog
	elog " If you want to run JBoss from Netbeans, add your user to 'jboss' group."
	elog 
	elog "for automatic WAR deployment under tomcat see: "
	elog "http://tomcat.apache.org/tomcat-5.5-doc/config/host.html#Automatic Application Deployment"
	elog ""
	elog ""
	elog "We provide now a tool to manage your multiple JBoss profiles"
	elog "see jboss-profiles-creator.sh --help for usage"
	elog
}
