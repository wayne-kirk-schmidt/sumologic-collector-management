#!/usr/bin/env bash
###
### SCRIPTNAME [ options ] - DESCRIPTION
###
###	-h | --help		display this message and exit
###	-v | --verbose		provide extra comments for verbose output
###	-d | --debug		run the script in complete verbose mode for debugging purposes
###	-s | --site		specify the Sumo Logic Site
###	-a | --apikey		specify the API credentials to use
###	-i | --identifier	specify the Sumo Logic identifier
###	-t | --type		specify the Sumo Logic Object Type
###
### Starting_Directory: BASEDIR
###

display_help () {

  scriptname=$( basename "$0" ) 
  startdir=$( ls -Ld "$PWD" ) 
  description="a wrapper for the Sumo Logic API to delete collectors"

  ( 
    grep -i -E '^###' | sed  's/^###//g' | \
    sed "s/SCRIPTNAME/$scriptname/g" | \
    sed "s#BASEDIR#$startdir#g"  | \
    sed "s#DESCRIPTION#$description#g"
  ) < "${0}"
  exit 0

}

initialize_variables () {

  ${debugflag}

  base=$( ls -Ld "$PWD" )			&& export base

  scriptname="${0%.*}"				&& export scriptname
  scripttag=$( basename "$scriptname" )		&& export scripttag

  cmddir=$( dirname "${scriptname}" )		&& export cmddir
  bindir=$( cd "$cmddir" ; pwd -P . )		&& export bindir

  basedir=$( dirname "${bindir}" )


  etcdir="$basedir/etc"				&& export etcdir
  cfgdir="$basedir/cfg" 			&& export cfgdir

  dstamp=$(date '+%Y%m%d')          		&& export dstamp
  tstamp=$(date '+%H%M%S')          		&& export tstamp
  lstamp="${dstamp}.${tstamp}"			&& export lstamp

  verboseflag=${verboseflag:-"false"}		&& export verboseflag
  content="Content-Type: application/json" 	&& export content
  jqcmd=$( which jq )				&& export jqcmd
  curlcmd=$( which curl )			&& export curlcmd

  sumo_target="${sumo_type:-"undefined"}"	&& export sumo_target
  [[ $sumo_type =~ "undefined" ]] && complain_and_exit 1 "sumo_type not defiined"

  sumo_myid="${sumo_id:-"undefined"}"		&& export sumo_myid
  [[ $sumo_myid =~ "undefined" ]] && complain_and_exit 1 "sumo_id not defiined"

  backup="/tmp/${sumo_target}.${lstamp}.json"	&& export bkupfile

}

initialize_environment () {

  ${debugflag}
  PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
  export PATH

  [[ ${BASH_VERSION%%.*} -ge 4 ]] || complain_and_exit 1 "script requires bash 4 or higher to run"

}

complain_and_exit () {

	exitmessage="$2"
	exitstatus="$1"
        echo "ERROR: ${exitmessage}"
        exit "${exitstatus}"
        
}

execute_request () {

  ${debugflag}

  sumo_target_url="https://api.${sumo_site}.sumologic.com/api/v1/${sumo_target}/${sumo_myid}"

  [ "${verboseflag}" ] && echo "archiving existing ${sumo_target} ... $sumo_myid ..."

  "${curlcmd}" -s -u "${sumo_apikey}" -X GET "${sumo_target_url}" > "${backup}" || \
  complain_and_exit 111 "unable to query $sumo_type - $sumo_id"

  [ "${verboseflag}" ] && echo "deleting  existing ${sumo_target} ... $sumo_myid ..."
  "${curlcmd}" -s -u "${sumo_apikey}" -X DELETE "${sumo_target_url}"

}

main_logic () { 

  umask 022

  initialize_environment
  initialize_variables
  execute_request
  

}
  
while getopts "hvds:a:i:n:t:" options;
do
  case "${options}" in
    h) display_help ; exit 0 ;;
    v) verboseflag='true'	; export verboseflag ;;
    d) debugflag='set -x'	; export debugflag ;;
    s) sumo_site=$OPTARG	; export sumo_site ;;
    a) sumo_apikey=$OPTARG	; export sumo_apikey ;;
    i) sumo_id=$OPTARG		; export sumo_id ;;
    n) sumo_name=$OPTARG	; export sumo_name ;;
    t) sumo_type=$OPTARG	; export sumo_type ;;
    *) display_help ; exit 0 ;;
  esac
done
shift $((OPTIND-1))

main_logic
