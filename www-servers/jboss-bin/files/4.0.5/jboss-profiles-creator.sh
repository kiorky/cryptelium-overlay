#!/bin/sh
#License: GPL2
#author: kiorky kiorky@cryptelium.net
PATH="${PATH}:/usr/lib/portage/bin"

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

usage(){
	echo
	echo "$0:"
	echo "	--profile=serverdir_template"
	echo "		* the name of the template to use to create the new profile "
	echo "		Default is 'gentoo'"
	echo "	--path=/path/to/profile_to_create"
	echo "		* don't use the leading / for a subdir of ${INSTALL_DIR}/server"		  
	echo "		* indicate the full location to other wanted location"
	echo "	--help" 
	echo "	-h"
	echo "	help"
	echo "		* print this helper"
	echo 
	echo "TIPS:"
	echo "	You must give the path to the profile"
	echo "	Either:"
	echo "		*    pathname (without leading /) for  for a subdir of ${INSTALL_DIR}/server"
	echo " 		*    /pathname for any other location (full path)"
	echo
	echo "Examples"
	echo "	$0 --profile=gentoo --path=/opt/newprofile"
	echo "		A new profile will be created in /opt/newprofile using \$jboss/server/gentoo as a template"
	echo "	$0 --profile=gentoo --path=newprofile"
	echo "		A new profile will be created in \$jboss/server/newprofile using \$jboss/server/gentoo as a template"
	echo

}



parse_cmdline() {
	# if no args are given
	if [[ $# -lt 1 ]];then
		echo "Please give Arguments"
		usage
		exit -1
	fi

	# print help if wanted
	if [[ $1 == "help" || $1 == "--help" || $1 == "-h" ]];then
		echo "Help wanted ?"
		usage
		exit
	fi
	
	# parse and validate arguments
        for arg in  ${@};do               
                if [[ $(echo $arg | sed -re "s/--.*=..*/GOOD/g" ) != "GOOD" ]]; then
			echo
			echo " You must specify --KEY=VALUE for your arguments"
			echo
			usage
			exit -1
                fi
                arg=$(echo $arg | sed -re "s/(--)(.*)(=.*)/\2/g")
                value=$(echo $arg | sed -re "s/(.*=)(.*)/\2/g")
                case "$arg" in
                    "profile")
			if [[ -e  ${jboss_path}/server/$value ]];then
				profile="${value}"
			else
				echo
				echo "Invalid profile"
				echo
				usage
				exit -1
			fi
                    ;;
                    "path")
		    	where=$(echo ${value}|sed -re "s/\/*$//"|sed -re "s/[^\/]*$//")
                    	if [[ -d ${where}  ]];then
		    		final_path="${where}"
			else
				echo
				echo "Invalid path"
				echo
				usage
				exit -1
			fi	
                   	;;           
                esac
	done

	# if default arguments are given
 	if [[ ${final_path} == "${default_final_path}" ]];then
		echo
		echo "Please change those default values"
		echo
		usage
		exit -1
	fi

	# clean variables
	# remove final slash if one
	profile=$(echo ${profile}|sed -re "s/\/*//")
	final_path=$(echo ${final_path}|sed -re "s/\/*$//")
	

}

#do the profile
# $1: profile
# $2: path to install
# $3: subdir of jboss if 1 / full path if 0
do_profile(){   
	profile=$1
	final_path=$2
	is_subdir=$3

	# do base direcotries
	keepdir  ${TMPDIR}/${profile}\
                 ${CACHEDIR}/${profile}\
                 ${RUNDIR}/${profile}\
                 ${LOGDIR}/${profile}\
	         ${CONFDIR}/${profile}
	
	# create directory
	mkdir -p ${final_path} ||  echo "Can't create profile directory" && exit -1 

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
        

main(){
        parse_cmdline ${@}
	if [[ ${final_path:0} == "/" ]];then
		echo "Installing in $profile dir"
		do_profile ${profile} ${final_path} 0
	else
		echo "Installing in $profile subdir"
		do_profile ${profile} ${final_path} 1
	fi
}
main ${@}
