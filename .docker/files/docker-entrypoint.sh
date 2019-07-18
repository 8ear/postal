#!/bin/sh
set -eu

SUDO=""
POSTAL_CONF_FILE="/opt/postal/config/postal.yml"

# Check if user is postal, if not change the commands to run in postal usermode
[ $(whoami) != "postal" ] && SUDO="gosu postal"


#Functions

parse_yaml {
   # https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}




if [ "$1" = "initialize-config" ]
then
    if [ -f "$POSTAL_CONF_FILE" ]
    then
        echo "Configuration file exists."
        parse_yaml $POSTAL_CONF_FILE "CONF_"
        printenv
        exit 0
    else
        echo "New Configuration file required."
        postal initialize-config
    fi

    exec update_postal_config
    exit 0
fi



# check if a command parameter exists
if [ $# = 0 ]
then
    # Start postal in foreground
    exec "$SUDO" postal run
else
    # If an extra command is given exectute this!
    exec "$SUDO" postal "$@"
fi
