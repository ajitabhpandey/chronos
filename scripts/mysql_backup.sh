#!/bin/sh
# Backup MySQL Databases.
# Each Database in seperate file
#
TGT="/home/ajitabhp/backup"
TS=`date +%Y%m%d`
USER='mysql_backup_user'
PASSWORD='password_of_user'

# Create the target directory if it does not exists
if [ ! -e $TGT ]
then
  mkdir -p $TGT
fi

# get a list of all databases excluding the default ones
DATABASES=`/usr/bin/mysql -u $USER -p$PASSWORD -e "SHOW DATABASES"|tr -d "| "|egrep -v "Database|information_schema|mysql|performance_schema"`

for DB in $DATABASES
do
  echo "Dumping Database: $DB"
  /usr/bin/mysqldump --force --opt --skip-lock-tables --user=$USER --password=$PASSWORD --databases $DB | /bin/gzip > $TGT/$TS.$DB.sql.gz
done
