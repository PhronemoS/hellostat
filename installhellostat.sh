#/bin/bash

# OS supported: Centos, Ubuntu, Slaclware


hellostat='/root/hellostat.sh'
rm -f $hellostat
sed -i '/\/root\/hellostat.sh/d' /root/.bashrc
wget -O $hellostat - https://raw.githubusercontent.com/PhronemoS/hellostat/master/hellostat.sh

IspP='/usr/local/ispmgr/bin/ispmgr'
CpanelP='/usr/local/cpanel/cpanel'
PleskP='/usr/local/psa/version'

P=1
distrib='SUSE|Fedora|PCLinuxOS|MEPIS|Mandriva|Debian|Damn|Sabayon|Slackware|KNOPPIX|Gentoo|Zenwalk|Mint|Ubuntu|Kubuntu|FreeBSD|Puppy|Freespire|Vector|Dreamlinux|CentOS|Arch|Xandros|Elive|SLAX|Red|BSD|KANOTIX|Nexenta|Foresight|GeeXboX|Frugalware|64|SystemRescue|Novell|Solaris|BackTrack|KateOS|Pardus'


for T in $IspP $CpanelP $PleskP
        do
                [ -s $T ] && break
                P=`expr $P + 1`
done

case $P in
	1) replace '#Panel' "echo \"Panel: \`/usr/local/ispmgr/bin/ispmgr -v\`\"" -- $hellostat ;;
	2) replace '#Panel' "echo \"Panel: cPanel \`/usr/local/cpanel/cpanel --version | grep -i \"cPanel \" | awk -F\"cPanel \" {'print \$2'} | awk {'print \$1'}\`\"" -- $hellostat ;;
	3) replace '#Panel' "echo \"Panel: Plesk \`cat /usr/local/psa/version | awk {'print \$1'}\`\"" -- $hellostat;;
esac

OS=`grep -Pwihs "($distrib)(.){0,} " /etc/{*release,*version} | sed -r 's/(.)+\="//; s/".*//' | head -1`
[ `echo -n $OS | wc -w` -gt 0 ] && sed -i "s/#distrib/distrib/g;s/#OS/OS/g" $hellostat

chmod 755 $hellostat
echo "$hellostat" >> /root/.bashrc

