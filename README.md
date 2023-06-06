# totum-docker-compose

Clone repo in need folder (this "/app"):
```
git clone https://github.com/DeAlexPesh/totum-docker-compose.git /app
```

Create file with params need: /app/compose/totum/.env
```
TZ=Etc/UTC
DB_USER=totum
DB_PASS=STRONG_DB_PASSWORD
DB_NAME=totum
DB_SCHEME=production
TOTUM_USER=admin
TOTUM_PASS=STRONG_TOTUM_PASSWORD
TOTUM_MAIL=ADMIN_MAIL
TOTUM_HOST=PROXY_DOMAIN
MEILI_KEY=00000000000000000000000000000000
```

For LDAP change value in file: /app/compose/totum/totum.yml
```
dns:
 - 192.168.0.0
dns_search: dc.domain.ru
```

In file /app/totum/Conf.php change variable for need value:
```
SERVICE_MAIL, SERVICE_MAIL_PASSWORD, STRONG_DB_PASSWORD, ADMIN_MAIL, PROXY_DOMAIN
```
Build
```
docker build -t images/totum:mode  /app/images/totum/. -f /app/images/totum/Dockerfile
```
Run
```
docker-compose -f /app/compose/totum/totum.yml up -d
```
ex: JSON for MeiliSearch
```
{
  "displayedAttributes": [
    "pk",
    "index",
    "catalog",
    "title",
    "text"
  ],
  "searchableAttributes": [
    "title",
    "index"
  ],
  "attributesForFaceting": [
    "catalog",
    "table"
  ]
}
```
ex: JSON for LDAP
```
{
  "LDAP_OPT_REFERRALS": "0",
  "LDAP_OPT_PROTOCOL_VERSION": "3"
}

{
  "dc.domain.ru": {
    "user": "read_user",
    "pass": "pass_user",
    "basedn": "dc=dc,dc=domain,dc=ru",
    "filter": "(&(memberOf=cn=totum,ou=IT,dc=dc,dc=domain,dc=ru)(|(objectCategory=person)))",
    "filter_single": "(&(objectCategory=person)({USER_LOGIN_PARAM}={USER_LOGIN}))"
  }
}

{
  "groups": "(&(objectCategory=group)(member={USER_DN}))"
}

{
  "groups": "totum"
}
```
