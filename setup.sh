#!/bin/bash

# System Monitoring scripts directory
SCRIPTSDIR="./scripts"

# System Monitoring scripts flat-file database
FLATFILE_DB="${SCRIPTSDIR}/system_monitoring_scripts.f2db"

error(){
	printf "\033[35mError:\t\033[31m${1}!\033[0m\n"
	exit 1
}

install_prerequisites(){
	sudo apt update -y
	sudo apt-get install build-essential nmap -y
}

create_flatfile_database(){
	# Remove flat-file if exists
	[ -f "${FLATFILE_DB}" ] && rm "${FLATFILE_DB}" && printf "Removed, older flatfile database!\n"
	# Create flat-file with name of scripts
	for f in $(find "${SCRIPTSDIR}" -type f -name '*.sh');
	do
		printf "\033[35mAdding, script \033[32m${f}\033[0m \033[35mto \033[36m${FLATFILE_DB}\033[0m\n"
		printf "$f\n" | tee -a "${FLATFILE_DB}"
	done
}

view_scripts(){
	if [ -e "${FLATFILE_DB}" ];
	then
		cat "${FLATFILE_DB}"
	fi
}

help_menu(){
	printf "\033[36mSetup System Monitoring\033[0m\n"
	printf "\033[35mCreate Flatfile\t\033[32m[ -c, create, --create ]\033[0m\n"
	printf "\033[35mShow Help Menu\t\033[32m[ -h, --help ]\033[0m\n"
	exit 0
}

if [ ${#@} -ge 1 ];
then
	for argv in $@
	do
		case $argv in
			-h|--help) help_menu;;
			-c|create|--create)
			install_prerequisites
			create_flatfile_database
			;;
			*) error "Invalid parameter was given";;
		esac
	done
else
	error "Missing a valid parameter"
fi
