#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

function info {
    echo -e "$GREEN$1$ENDCOLOR" 
}

echo ""
read -p "php version: " php_version
echo ""

info "---------------------------------------------------"
info " Determine system RAM and average pool size memory "
info "---------------------------------------------------"
echo ""

# memTotal=$(free -m | awk '/Пам/{print $2}')
# memFree=$(free -m | awk '/Пам/{print $4}')
info "> Memory"
echo ""
free -hw
echo ""

info "> Fpm processes"
echo ""
ps -ylC php-fpm$phpVersion --sort:rss
echo ""

fpmProcessAvgSize=`ps --no-headers -o "rss,cmd" -C php-fpm$phpVersion | awk '{ sum+=$1 } END { printf ("%d", sum/NR/1024) }'`
info "> Fpm process AVG size"
echo ""
echo "${fpmProcessAvgSize} Mb"
echo ""

info "> All fpm processes memory"
echo ""
ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | grep php-fpm
echo ""

info "---------------------------------------------------"
info " Calculate max_children                            "
info "---------------------------------------------------"
echo ""

# pm.max_children = Total RAM dedicated to the web server / Max child process size

read -p "fpm dedicated RAM, Mb  : " fpmDedicatedRam
read -p "fpm max child size, Mb : " fpmChildMaxSize
echo ""

let fpmChildMaxCount=$fpmDedicatedRam/$fpmChildMaxSize
echo $fpmChildMaxCount
echo ""
