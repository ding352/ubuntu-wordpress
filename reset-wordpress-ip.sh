#!/bin/bash

IP=$(ifconfig eth0 |awk -F '[ :]+' 'NR==2 {print $4}')

MYSQL_DATABASE=wordpress
MYSQL_USERNAME=root
MYSQL_PASSWORD=root


SQL="UPDATE $MYSQL_DATABASE.wp_posts SET guid=REPLACE (guid,IF( RIGHT(LEFT(guid,22),1)>0, LEFT(guid,22),IF(RIGHT(LEFT(guid,21),1)>0,LEFT(guid,21),LEFT(guid,20))),CONCAT('http://','$IP')) WHERE LEFT(guid,7)='http://'; UPDATE $MYSQL_DATABASE.wp_options SET option_value=REPLACE (option_value,IF( RIGHT(LEFT(option_value,22),1)>0, LEFT(option_value,22),IF(RIGHT(LEFT(option_value,21),1)>0,LEFT(option_value,21),LEFT(option_value,20))),CONCAT('http://','$IP')) WHERE $MYSQL_DATABASE.wp_options.option_name IN ('siteurl','home');"

echo $IP
echo $MYSQL_DATABASE
echo $MYSQL_USERNAME
echo $MYSQL_PASSWORD
echo $SQL

mysqldump -hlocalhost -u$MYSQL_USERNAME -p$MYSQL_PASSWORD --skip-lock-tables $MYSQL_DATABASE |pv|gzip > "$MYSQL_DATABASE"_$(date +"%Y-%m-%d").backup.sql.gz;


mysql --batch --silent $MYSQL_DATABASE -u$MYSQL_USERNAME -p$MYSQL_PASSWORD -e "$SQL"
