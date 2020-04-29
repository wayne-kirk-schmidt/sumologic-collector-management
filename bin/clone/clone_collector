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
###	-n | --name		specify the Sumo Logic name
###
### Starting_Directory: BASEDIR
###

display_help () {

  scriptname=$( basename "$0" ) 
  startdir=$( ls -Ld "$PWD"  ) 
  description="a wrapper for the Sumo Logic API to clone collectors"

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

  ctmpfile="/tmp/collector.$lstamp.json"	&& export ctmpfile
  stmpfile="/tmp/source.$lstamp.json"		&& export stmpfile

}

initialize_environment () {

  ${debugflag}
  PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
  export PATH
  rm -f "${ctmpfile}" "${stmpfile}"

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

  sumohttp="https://api.${sumo_site}.sumologic.com/api/v1/collectors"
  src_c_url="${sumohttp}/${sumo_id}"
  src_s_url="${sumohttp}/${sumo_id}/sources"

  "${curlcmd}" -s -u "${sumo_apikey}" -X GET "${src_c_url}" | \
  "${jqcmd}" -r 'keys[] as $k | "\(.[$k] | .id) \(.[$k] | .name)"' | \
  while read -r src_id src_name
  do
    [ "${verboseflag}" ] && echo "querying old collector sources: ... $src_id i ... $src_name ..."
    "${curlcmd}" -s -u "${sumo_apikey}" -X GET "${src_c_url}" | \
    sed "s/${src_name}/${sumo_name}/g" | "${jqcmd}" 'del(.collector["id", "links"])' > "${ctmpfile}"

    [ "${verboseflag}" ] && echo "creating new collector: ... $sumo_name ..."
    copy_id=$( 
      "${curlcmd}" -s -u "${sumo_apikey}" -X POST -H "${content}" -T "${ctmpfile}" "${sumohttp}" | \
      "${jqcmd}" -r 'keys[] as $k | "\(.[$k] | .id)"'
    )
    rm -f "${ctmpfile}"
    dst_s_url="${sumohttp}/${copy_id}/sources"

    "${curlcmd}" -s -u "${sumo_apikey}" -X GET "${src_s_url}" | \
    "${jqcmd}" -r '.sources | keys[] as $k | "\(.[$k] | .id)"' | \
    while read -r src_s_id
    do
        [ "${verboseflag}" ] && echo "cloning sources: ... $src_s_id ..."
        "${curlcmd}" -s -u "${sumo_apikey}" -X GET "${src_s_url}/${src_s_id}" | \
        "${jqcmd}" 'del(.source["id", "links", "url"])' | \
        "${jqcmd}" '. += {"api.version": "v1"}' | \
        sed "s/${src_name}/${sumo_name}/g" > "${stmpfile}"
        dst_s_id=$( 
          "${curlcmd}" -s -u "${sumo_apikey}" -X POST -H "${content}" -T "${stmpfile}" "${dst_s_url}" | \
          "${jqcmd}" -r 'keys[] as $k | "\(.[$k] | .id)"' 
        )
        [ "${verboseflag}" ] && echo "cloning sources: ... $src_s_id ... $dst_s_id ..."
    done
  done
}

main_logic () { 

  umask 022

  initialize_environment
  initialize_variables
  execute_request

}
  
while getopts "hvds:a:i:n:" options;
do
  case "${options}" in
    h) display_help ; exit 0 ;;
    v) verboseflag='true'	; export verboseflag ;;
    d) debugflag='set -x'	; export debugflag ;;
    s) sumo_site=$OPTARG	; export sumo_site ;;
    a) sumo_apikey=$OPTARG	; export sumo_apikey ;;
    i) sumo_id=$OPTARG		; export sumo_id ;;
    n) sumo_name=$OPTARG	; export sumo_name ;;
    *) display_help ; exit 0 ;;
  esac
done
shift $((OPTIND-1))

main_logic
