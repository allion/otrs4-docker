#!/bin/bash
service mysqld start &
wait
mysql -uroot -e "CREATE DATABASE otrs CHARACTER SET utf8 COLLATE utf8_general_ci;CREATE USER 'otrs'@'localhost' IDENTIFIED BY 'otrs';GRANT ALL PRIVILEGES ON otrs.* TO 'otrs'@'localhost' WITH GRANT OPTION;"&
wait
cat /opt/otrs/scripts/database/otrs-schema.mysql.sql | mysql -f -u root otrs &
wait
cat /opt/otrs/scripts/database/otrs-initial_insert.mysql.sql | mysql -f -u root otrs &
wait
/opt/otrs/bin/otrs.SetPassword.pl --agent root@localhost root &
wait
/opt/otrs/bin/otrs.RebuildConfig.pl &
wait
/opt/otrs/bin/Cron.sh start otrs &
wait
curl -o Znuny4OTRS-Repo.opm http://portal.znuny.com/api/addon_repos/public/1420
/opt/otrs/bin/otrs.PackageManager.pl -a install -p Znuny4OTRS-Repo.opm &
wait
service httpd start
wait
service crond start
exec /usr/sbin/sshd -D
