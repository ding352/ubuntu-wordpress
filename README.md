# wordpress
include mysql-server-5.5,apache2,php5,php-mysql

use supervisor to manage the mysql and apache2

how to run the wordpress:

docker run -d --name wordpress -p 3306:3306 -p 80:80 loading/wordpress

