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
final_name="gentoo"
forbidden_to_install_in="/ /bin /include /lib /sbin /usr/bin /usr/include /usr/lib /usr/sbin"
XARGS="/usr/bin/xargs"

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
			eerror "	File \"$3\" exists in \"$2\" directory"
			;;		
		"invalid_path")
			eerror "Invalid path: $HILITE  $2"
			;;
		"profile_invalid_subdir")
			eerror "Invalid profile"					
			eerror "    Invalid JBOSS Servers subdir: $HILITE $2"
			;;
		"profile_invalid_full_path")
			eerror "Invalid profile"
			eerror "    Invalid full_path: $HILITE $2"
			;;
		"invalid_args")
			eerror " You must specify --KEY=VALUE for your arguments"
			;;
		"invalid_profile")
			eerror "Profile is invalid"
			eerror "     subdir for this profile is missing: $HILITE $2"
			;;
		"no_path_given")
			eerror "Please specify where you want to install your profile"
		;;
		"no_arg")
			eerror "Please give Arguments"
			;;		
		"cant_create_dir")
			eerror "Can't create profile directory"
			exit -1
			;;
		"help")
			eerror "Help wanted ?"
			eerror;usage;exit
			;;
		"profile_exists")
			eerror "Profile  exists: $HILITE $2"
			;;
		"delete_no_profile")
			eerror "Invalid profile to delete: $HILITE $2"			
			;;
		"path_not_exists")
			eerror "Please specify a valid final path"
			eerror "	Final profile path doest not exist: $HILITE $2" 
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
	einfo "$HILITE	--list"
	einfo "		* List actual profiles"
	einfo "$HILITE	--delete=profile_name"
	einfo "		* Delete a profile"
	einfo "		* You can get profiles with --list"
	einfo "		* eg: $0 --delete=gentoo"
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
# $1 : profile name
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



# list actual profiles
list_profiles() {
	einfo "Installed profiles :"
	for i in  $(ls -d ${default_final_path}/* ) ;do
		if [[ -L "$i" ]];then
			einfo "$HILITE $(echo $i|sed -re "s:${default_final_path}/*::g")"
 			einfo "		Server subdir:		$i"
			einfo "		Real path: 		$(ls -dl "$i" | awk -F " " '{print $11 }')"
		else
			einfo "sdqf		$HILITE $i"
		fi
	done;
}


# parse command lines arguments
parse_cmdline() {
	local arg value l_final_name
	# if no args are given
	if [[ $# -lt 1 ]];then
		do_error "no_arg"
	fi	
	
	case $1 in
		# print help if wanted
		"help" |  "--help" | "-h")
			do_error "help"		
		;;
		"--list" | "-l" | "--l")
			list_profiles
			exit
		;;
	esac
	
	# parse and validate arguments
        for param in  ${@};do               
                if [[ $(echo ${param} | sed -re "s/--.*=..*/GOOD/g" ) != "GOOD" ]]; then
			do_error "invalid_args"
                fi
                arg=$(echo ${param} | sed -re "s/(--)(.*)(=.*)/\2/g")
                value=$(echo ${param} | sed -re "s/(.*=)(.*)/\2/g")
                case "$arg" in			
                    "profile")
			if [[ ${value:0:1} == "/" || ${value:0:2} == "./"  ]];then	
				#full or relative path is given
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
		    "delete")
		    	delete_profile ${value}
			exit
		    ;;
                    "path")
			# remove final slash if one
			value=$(echo ${value}|sed -re "s/(\/*[^\/]+)\/*$/\1/")
			# is there a profile or a full path
			if [[ ${value:0:2} == "./" ]];then				
				# if relative getting full
				value="$(pwd|sed -re "s:(.*)/*$:\1/:")$(echo ${value}|sed -re "s:\./::g")"
			fi
			if [[ ${value:0:1} == "/" ]];then
				is_subdir=0
			else				
				# if profile, verify that s the name doesnt contains any other path
				[[ $(echo ${value}|grep "/" |grep -v grep|wc -l  ) -gt 0 ]] \
					&& do_error "profile_invalid_subdir" ${value}
				value=${default_final_path}/${value}
				is_subdir=1
			fi
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
			final_name="$(echo ${value}|sed -re "s:(.*/)([^/]*)($):\2:")"
			[[ -e ${default_final_path}/${final_name} ]] && do_error "profile_exists" ${final_name}
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



# adds ".keep" files so that dirs aren't auto-cleaned
keepdir() {
        mkdir -p "$@"
        local x
        if [ "$1" == "-R" ] || [ "$1" == "-r" ]; then
                shift
                find "$@" -type d -printf "%p/.keep_www-server_jboss-bin_4\n" |\
			 tr "\n" "\0" | $XARGS -0 -n100 touch ||\
			 die "Failed to recursive create .keep files"
        else
                for x in "$@"; do
                        touch "${x}/.keep_www-server_jboss-bin_4" ||\
				die "Failed to create .keep in ${D}/${x}"
                done
        fi
}

# delete a profile
# $1: profile name
delete_profile(){   
	profile=$1 
	final_path="${default_final_path}/$1"
	if [[ -L ${final_path} ]];then
		final_path="$(ls -dl "${final_path}" | awk -F " " '{print $11 }')"

	elif [[ -d ${final_path} ]];then
		echo>>/dev/null
	else
		do_error "delete_no_profile" $profile
	fi

	final_name=${profile}

	ewarn "Deleting profile: $HILITE $profile"
	ewarn "Path: $HILITE ${final_path}"
	print_yes_no
	# delete if symlick
	[[ -L ${default_final_path}/${final_name} ]] &&	rm -rf ${default_final_path}/${final_name}

	# delete run files
	rm -rf   ${TMPDIR}/${final_name}\
                 ${CACHEDIR}/${final_name}\
                 ${RUNDIR}/${final_name}\
                 ${LOGDIR}/${final_name}\
	         ${CONFDIR}/${final_name}\
	 	 ${final_path} \
		 ${CONFDIR}/${final_name}/conf \
		 ${CONFDIR}/${final_name}
}


# do the profile
# $1: profile
# $2: path to install
# $3: subdir of jboss if 1 / full path if 0
do_profile(){   
	profile=$1 
	final_path=$2	
	is_subdir=$3

	ewarn "Creating profile in ${final_path}"
	ewarn "Using ${profile} profile"


	# do base direcotries

	keepdir  ${TMPDIR}/${final_name}\
                 ${CACHEDIR}/${final_name}\
                 ${RUNDIR}/${final_name}\
                 ${LOGDIR}/${final_name}\
	         ${CONFDIR}/${final_name}
	# create directory
	mkdir -p ${final_path} ||  do_error "cant_create_dir"

 	# copy profile
	for i in  conf deploy  lib;do
		cp -rf ${jboss_path}/server/${profile}/$i ${final_path}/ 
	done

	# do runtime files stuff
	ln -s ${LOGDIR}/${final_name}     ${final_path}/logs
	ln -s ${CACHEDIR}/${final_name}   ${final_path}/data
	ln -s ${TMPDIR}/${final_name}     ${final_path}/tmp
	ln -s ${RUNDIR}/${final_name}     ${final_path}/run

	# do /etc stuff
	ln -s ${final_path}/conf       ${CONFDIR}/${final_name}/conf
	ln -s ${final_path}/deploy/jbossweb-tomcat55.sar/server.xml ${CONFDIR}/${final_name}

	# if we don't create in jboss directory, link the profile in jboss servers dir
	[[ is_subdir -eq 0 ]] && ln -s ${final_path} ${jboss_path}/server/${final_name}

	# fix perms
	for i in ${TMPDIR}/${final_name}   ${CACHEDIR}/${final_name} \
		 ${RUNDIR}/${final_name}   ${LOGDIR}/${final_name}   \
		 ${CONFDIR}/${final_name}  ${CONFDIR}/${final_name}  \
		 ${final_path};do
		 chmod -Rf 755 $i;
		chown -R jboss:jboss $i;
	done
}
        
# print collected informations
# $1: subdir of jboss if 1 / full path if 0
print_information() {
	ewarn "Jboss profile manager for : $HILITE ${final_name}"
	if [[ $1 -eq 0 ]];then		
		ewarn "Installing  in directory: $HILITE${final_path} "
		ewarn "Using profile:           $HILITE${profile} "
	else
		ewarn "Installing in subdir: $HILITE ${final_path}"
		ewarn "Using profile:        $HILITE ${profile} "
	fi
}

# print a yes_no like form
# exit on failure / no
# continue if yes
print_yes_no(){
	local i nb nok="nok";
	while [[ nok == "nok" ]];do
		[[ $nb -gt 12 ]] && eerror "Invalid arguments" && exit -1
		[[ $nb -gt 10 ]] && ewarn "Please Enter CTRL-C to exit "\
				 && ewarn " or \"Y\" to say YES"\
				 && ewarn " or \"N\" to say NO"
		ewarn " Is that Correct (Y/N) ???"
		read i;
		[[ $i == "Y" || $i == "y" ]] && break
		[[ $i == "N" || $i == "n" ]] && einfo "User wanted interrupt" && exit
		nb=$((nb+1))
	done
}

main(){
        parse_cmdline ${@}
	print_information ${is_subdir}
	print_yes_no
	do_profile ${profile} ${final_path} ${is_subdir}
}
main ${@}
