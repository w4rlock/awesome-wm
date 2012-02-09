#!/bin/bash
#===============================================================================
#
#          FILE:  info.sh
# 
#         USAGE:  ./info.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  
#         EMAIL:  warlock.gpl@gmail.com 
#       VERSION:  1.0
#       CREATED:  02/20/2011 04:42:11 PM ART
#      REVISION:  ---
#===============================================================================
#echo -e ${LBLUE}
LBLUE="\033[1;34m"
LGREEN="\033[1;32m"
LRED="\033[1;31m"    

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ERROR
function getError()
{
    echo -e $LRED "\n\t Error: especifique un parametro\n"
    exit 1
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- HELP
function getHelp()
{   echo -e ${LBLUE} "\nOPTIONS:" ${LGREEN}
    echo -e "\t-b : Muestra informacion de la batteria."
    echo -e "\t-m : Muestra informacion de mpd.\n"
    exit 0
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- BATTERY
function getBat()
{
    CARGADA="charged,"
    CARGANDO="charging,"
    STATE=`acpitool -b | awk '{print $4}'`
    if [[ $STATE == $CARGANDO ]]; then
        RES='+'
    elif [[ $STATE != $CARGADA ]]; then
        RES='-' 
    fi
    RES=${RES}`acpitool -b | awk '{print $5}'`
    CANT=$(expr length $RES) 
    echo ${RES:0:$CANT-1} #elimino la , que tiene al final
    exit 0
}

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- MPD
function getMpd()
{
    ARTIST=`mpc current -f %artist%`
    TITLE=`mpc current -f %title%`
    echo ${ARTIST}' - '${TITLE}
    exit 0
}

# MAIN
if [[ $# -lt 1 ]]; then
    #getError
    getHelp
fi

case $1 in
   -b|--bat) getBat  ;;
   -m|--mpd) getMpd  ;;
  -h|--help) getHelp ;;
esac
