#!/bin/bash
set -e

error()
{
    echo "ERROR:" "$@" 1>&2
}

#enable apache modules
IFS=', ' read -r -a array <<< "$MODULES"
for element in "${array[@]}"
do
    a2enmod $element
done

#run other script (cron, modules, etc)
if [ ! -f "$SHFILE" ]
then
  echo "file not found"
else
  chmod +x $SHFILE
  echo "run $SHFILE"
  $SHFILE
fi

#apply changes
service apache2 restart

exec entrypoint
