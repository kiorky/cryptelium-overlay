#!/bin/sh
#License: GPL2
#author: kiorky kiorky@cryptelium.net
PATH="${PATH}:/usr/lib/portage/bin"
source /etc/init.d/functions.sh

JBOSS_VERSION="jboss-bin-4"
default_profile="gentoo"
default_final_path="/opt/${JBOSS_VERSION}/server"

CONFDIR="/etc/${JBOSS_VERSION}/"
TMPDIR="/var/tmp/${JBOSS_VERSION}"
CACHEDIR="/var/cache/${JBOSS_VERSION}"
RUNDIR="/var/run/${JBOSS_VERSION}"
LOGDIR="/var/log/${JBOSS_VERSION}"
jboss_path="/opt/${JBOSS_VERSION}"
profile="${default_profile}" 
final_path="${default_final_path}"
forbidden_to_install_in="/ /bin /include /lib /sbin /usr/bin /usr/include /usr/lib /usr/sbin"


# error management
# usage: do_error "theerror" ARGS
# read the code as it is enought explicit to use
# some errors can take arguments !!
do_error(){
	eerror
	case $1 in
		"forbidden")
			eerror "Please specify another location"
			eerror "	Creating profiles in \"$2\" is forbidden !!!"
			;;
		"file_exists")
			eerror "Profile is even created  ?"
			eerror "	File $3 exists in $2 directory"
			;;		
		"invalid_path")
			eerror "Invalid path: $2"
			;;
		"profile_invalid_subdir")
			eerror "Invalid profile"					
			eerror "    Invalid JBOSS Servers subdir: $2"
			;;
		"profile_invalid_full_path")
			eerror "Invalid profile"
			eerror "    Invalid full_path: $2"
			;;
		"invalid_args")
			eerror " You must specify --KEY=VALUE for your arguments"
			;;
		"invalid_profile")
			eerror "Profile is invalid"
			eerror "     subdir:  \"$2\" for this profile is missing"
			;;
		"no_path_given")
			eerror "Please specify where you want to install your profile"
		;;
		"no_arg")

			eerror "Please give Arguments"
			;;		
		"help")
			eerror "Help wanted ?"
			eerror;usage;exit
			;;
		"path_not_exists")
			eerror "Please specify a valid final path"
			eerror "	Final profile path doest not exist: $2" 
			;;
		*)
			eerror 
			usage
			exit # not error there !!!
	esac
	eerror 
	usage
	exit -1
}


# print usage 
usage(){
	einfo
	einfo "$BRACKET Usage: "
	einfo "$HILITE JBoss profile Manager"
	einfo
	einfo
	einfo "$BRACKET $0:"
	einfo "$HILITE	--profile=serverdir_template"
	einfo "		* the name of the template to use to create the new profile "
	einfo "		Default is 'gentoo'"
	einfo "$HILITE	--path=/path/to/profile_to_create"
	einfo "		* don't use the leading / for a subdir of ${INSTALL_DIR}/server"		  
	einfo "		* indicate the full location to other wanted location"
	einfo "$HILITE	--help" 
	einfo "$HILITE	-h"
	einfo "$HILITE	help"
	einfo "		* print this helper"
	einfo 
	einfo "$BRACKET TIPS:"
	einfo "	You must give the path to the profile"
	einfo "	Either:"
	einfo "		*    pathname (without leading /) for  for a subdir of ${INSTALL_DIR}/server"
	einfo " 		*    /pathname for any other location (full path)"
	einfo
	einfo "$BRACKET Examples"
	einfo "	$0 --profile=gentoo --path=/opt/newprofile"
	einfo "		A new profile will be created in /opt/newprofile using \$jboss/server/gentoo as a template"
	einfo "	$0 --profile=gentoo --path=newprofile"
	einfo "		A new profile will be created in \$jboss/server/newprofile using \$jboss/server/gentoo as a template"
	einfo

}

# verfiry a jboss profile
# exit and print usage if profile is invalid 
# continue either
verify_profile() {
	local value=$1
	for i in conf lib deploy;do
		if [[ ! -e ${value}/$i ]];then
			do_error "invalid_profile" $i
		fi
	done

}

# parse command lines arguments
parse_cmdline() {
	local arg value 
	# if no args are given
	if [[ $# -lt 1 ]];then
		do_error "no_arg"
	fi
	# print help if wanted
	if [[ $1 == "help" || $1 == "--help" || $1 == "-h" ]];then
		do_error "help"		
	fi
	
	# parse and validate arguments
        for param in  ${@};do               
                if [[ $(echo ${param} | sed -re "s/--.*=..*/GOOD/g" ) != "GOOD" ]]; then
			do_error "invalid_args"
                fi
                arg=$(echo ${param} | sed -re "s/(--)(.*)(=.*)/\2/g")
                value=$(echo ${param} | sed -re "s/(.*=)(.*)/\2/g")
                case "$arg" in
                    "profile")
			if [[ ${value:0:1} == "/" ]];then	
				#fullpath given
				if [[  -e   ${value} ]]; then
					verify_profile ${value}
					profile="${value}"
				else
					do_error "profile_invalid_full_path" ${value}
				fi					
			# subdir given
			elif [[ -e  ${jboss_path}/server/$value ]];then
				verify_profile ${jboss_path}/server/$value
				profile="${value}"				
			else
				do_error "profile_invalid_subdir" ${value}
			fi
			;;
                    "path")
			# remove final slash if one
			value=$(echo ${value}|sed -re "s/(\/*[^\/]+)\/*$/\1/")
			for forbidden in ${forbidden_to_install_in};do
				if [[ $(echo ${value}|sed -re "s:^($forbidden):STOP:") == "STOP" ]];then
					do_error "forbidden" ${forbidden}
				fi
			done
			# if final directory is even created
			# we control that we do not overwrite an existing profile
                    	if [[ -d ${value} || -L ${value}  ]];then
				for i in conf data lib run tmp deploy;do
					[[ -e ${value}/$i ]] && do_error "file_exists" "${value}" "$i"
				done
			fi
		    	final_path="${value}"
                   	;;           
                esac
	done

	# if default arguments are given
 	if [[ ${final_path} == "${default_final_path}" ]];then
		do_error "no_path_given" 
	fi

	# clean variables
	# remove final slash if one
	profile=$(echo ${profile}|sed -re "s/\/*//")
	final_path=$(echo ${final_path}|sed -re "s/\/*$//")
}

# do the profile
# $1: profile
# $2: path to install
# $3: subdir of jboss if 1 / full path if 0
do_profile(){   
	profile=$1
	final_path=$2
	is_subdir=$3
	exit -1
	# do base direcotries
	keepdir  ${TMPDIR}/${profile}\
                 ${CACHEDIR}/${profile}\
                 ${RUNDIR}/${profile}\
                 ${LOGDIR}/${profile}\
	         ${CONFDIR}/${profile}
	
	# create directory
	mkdir -p ${final_path} ||  eerror "Can't create profile directory" && exit -1 

 	# copy profile
	for i in  conf deploy  lib;do
		cp -rf ${jboss_path}/server/${profile}/$i ${final_path}/
	done

	# do runtime files stuff
	ln -s ${LOGDIR}/${profile}     ${final_path}/logs
	ln -s ${CACHEDIR}/${profile}   ${final_path}/data
	ln -s ${TMPDIR}/${profile}     ${final_path}/tmp
	ln -s ${RUNDIR}/${profile}     ${final_path}/run

	# do /etc stuff
	ln -s ${final_path}/conf       ${CONFDIR}/${profile}
	ln -s ${final_path}/deploy/jbossweb-tomcat55.sar/server.xml ${CONFDIR}/${profile}

	# if we don't create in jboss directory
	[[ is_subdir -eq 0 ]] && ln -s ${final_path} ${jboss_path}/server
	
	# fix perms
	for i in ${TMPDIR}/${profile}   ${CACHEDIR}/${profile} \
		 ${RUNDIR}/${profile}   ${LOGDIR}/${profile}   \
		 ${CONFDIR}/${profile}  ${CONFDIR}/${profile}  \
		 ${final_path};do
		 chmod -Rf 755 $i;
		 chown -R jboss:jboss $i;
	done
}
        
# do the profile
# $1: subdir of jboss if 1 / full path if 0
print_information() {
	if [[ $1 -eq 1 ]];then		
		ewarn "Jboss profile manager:"
		ewarn "Installing in directory: $HILITE${final_path} "
		ewarn "Using profile:           $HILITE${profile} "
		ewarn " Is that Correct (Y/N) ???"
	else
		ewarn "Jboss profile manager:"
		ewarn "Installing in subdir: $HILITE ${final_path}"
		ewarn "Using profile:        $HILITE ${profile} "
		ewarn " Is that Correct (Y/N) ???"
	fi
}

main(){
        parse_cmdline ${@}
	if [[ ${final_path:0:1} == "/" ]];then
		print_information 0
	else 
		print_information 1
	fi
	local i nb nok="nok";
	while [[ nok == "nok" ]];do
		[[ $nb -gt 12 ]] && eerror "Invalid arguments" && exit -1
		[[ $nb -gt 10 ]] && ewarn "Please Enter CTRL-C to exit "\
				 && ewarn " or \"Y\" to say YES"\
				 && ewarn " or \"N\" to say NO"
		read i;
		[[ $i == "Y" || $i == "y" || $i=="N" || $i == "n" ]] && nok="ok"
		nb=$((nb+1))
	done
	if [[ ${final_path:0:1} == "/" ]];then
		do_profile ${profile} ${final_path} 0
	else 
		do_profile ${profile} ${final_path} 1
	fi
}
main ${@}
