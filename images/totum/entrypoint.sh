#!/usr/bin/env bash
set -e
while read -r var; do
 if [ -z "${!var}" ]; then echo "ENV $var not init..." && exit 1
 elif [[ $var != *"PASSWORD"* ]]; then echo "$var: ${!var}"
 fi
done << EOF
TOTUM_USER
TOTUM_PASSWORD
TOTUM_MAIL
TOTUM_HOST
TOTUM_DB_USER
TOTUM_DB_PASSWORD
TOTUM_DB_NAME
TOTUM_DB_SCHEME
EOF

chown totum:totum /home/totum/totum/Conf.php
chown totum:totum -R /home/totum/totum/http/fls

if [ ! -s /home/totum/totum/Conf.php ]; then
 su - totum -c "/bin/totum install --pgdump=pg_dump --psql=psql \
  -e -- \
  '${TOTUM_LANG}' '${TOTUM_INST}' '${TOTUM_DB_SCHEME}' '${TOTUM_MAIL}' '${TOTUM_HOST}' '${TOTUM_USER}' '${TOTUM_PASSWORD}' \
  '${TOTUM_DB_NAME}' '${TOTUM_DB_HOST}' '${TOTUM_DB_USER}' '${TOTUM_DB_PASSWORD}' '${TOTUM_DB_PORT}'"
fi
echo -e "\n-------\nSUPERVISORD Run..." && supervisord -c /etc/supervisor/supervisord.conf