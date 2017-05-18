#!/bin/bash

# Generated by PhronemoS
# Last updated 24.02.2013

###############
### Colors ####
###############

##FUNN SKULL##
#clear
#cat /root/skulltest/1 
#sleep 0.3
#clear
#cat /root/skulltest/2
#sleep 0.3
#clear
#cat /root/skulltest/3
#sleep 0.3
#clear
#cat /root/skulltest/4
#sleep 0.3
#clear
#cat /root/skulltest/5
## END SKULL ##

red='\033[31m'
green='\033[32m'
yellow='\033[33m'

##########
distrib='SUSE|Fedora|PCLinuxOS|MEPIS|Mandriva|Debian|Damn|Sabayon|Slackware|KNOPPIX|Gentoo|Zenwalk|Mint|Ubuntu|Kubuntu|FreeBSD|Puppy|Freespire|Vector|Dreamlinux|CentOS|Arch|Xandros|Elive|SLAX|Red|BSD|KANOTIX|Nexenta|Foresight|GeeXboX|Frugalware|64|SystemRescue|Novell|Solaris|BackTrack|KateOS|Pardus'

printf "\n"

echo "------------------------ Server ------------------------"

a=10
set `cat /proc/loadavg`
if [ `echo ${1} | awk -F"." {'print $1'}` -lt $a ] ; then
	echo "Load average: ${1} ${2} ${3}"
	else echo -e "${red}Load average: ${1} ${2} ${3}" ; tput sgr0 ; exit 1
fi

echo -e "${yellow}Hostname: `echo $HOSTNAME`" ; tput sgr0

OS=`grep -Pwihs "($distrib)(.){0,} " /etc/{*release,*version} | sed -r 's/(.)+\="//; s/".*//' | head -1` ; [ `echo -n $OS | wc -w` -gt 0 ] && echo "OS: $OS"

#Panel

echo "Primary IP: `ifconfig | grep "inet addr" | head -n1 | awk -F: '{print $2}' | awk '{print $1}'`"

##########
service_status () {
	echo -n "$1 [ "
	case $2 in
		0) echo -en "${green}OK" ;;
		*) echo -en "${red}ERROR" ; tput sgr0 ;;
	esac
	tput sgr0
	echo -n " ]"
}

echo -e "\n------------------- Service status ---------------------"

if [ `which php-fpm 2>/dev/null | wc -w` -gt 0 ]
	then
		[ `pidof php-fpm | wc -w` -gt 0 ]
		service_status PHP-FPM $?
		printf "\t"
	else
		[ `pidof httpd | wc -w` -gt 0 -o `pidof apache2 | wc -w` -gt 0 ]
		service_status APACHE $?
		printf "\t"
fi

[ `pidof mysql | wc -w` -gt 0 -o `pidof mysqld | wc -w` -gt 0 ]
service_status MYSQL $?
[ `which nginx 2>/dev/null | wc -w` -gt 0 ] && ( printf "\t" ; [ `pidof nginx | wc -w` -gt 0 ] ; service_status NGINX $? )
printf "\n"

##########
# Free disc space & inodes

a=`df -h | grep -P "(([89]\d)|100)%"`
b=`df -i | grep -P "(([89]\d)|100)%"`
if [ `echo "$a" | wc -w` -gt 0 -o `echo "$b" | wc -w` -gt 0 ] ; then
	echo "------------------------- Disc -------------------------"
	if [ `echo "$a" | wc -w` -gt 0 ] ; then
		echo "Warning SPACE:"
#		printf "Path\tTotal\tUsage\tFree\tUsage(proc)\tMounted\n"
		echo -e "${red}$a" ; tput sgr0
	fi
##########
# Free inodes

	if [ `echo "$b" | wc -w` -gt 0 ] ; then
	        echo "Warning INODES:"
#	        printf "Path\tTotal\tUsage\tFree\tUsage(proc)\tMounted\n"
	        echo -e "${red}$b" ; tput sgr0
	fi
fi
##########
# Memory status red=not good, a=memory limit

echo "------------------------ Memory ------------------------"

a=200
set `free -m | grep 'buffers/cache' | awk {'print $3, $4'}`

if [ $2 -lt $a ] ; then
        echo -e "${red}Used = ${1} M ; free = ${2} M" ; tput sgr0
	else
        echo "Used = ${1} M ; free = ${2} M"
fi

echo "--------------------------------------------------------"
##########
LOGIN_USERS=`who`
if [ `echo $LOGIN_USERS | wc -w` -gt 0 ] ; then
	echo "Users logged in:"
	echo "$LOGIN_USERS"
	echo "--------------------------------------------------------"
fi
##########
printf "\n"
exit 0
