component=mysql
log="/tmp/$component.log"

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mDisabling the current MySQL module.\e[0m" | tee -a $log
dnf module disable mysql -y &>> $log

echo -e "\e[32mConfiguring the ${component} repository.\e[0m" | tee -a $log
cp repository-files/mysql.repo /etc/yum.repos.d/mysql.repo &>> $log

echo -e "\e[32mInstalling MySQL Community Server.\e[0m" | tee -a $log
dnf install mysql-community-server -y &>> $log

echo -e "\e[32mEnabling and starting the mysqld service.\e[0m" | tee -a $log
systemctl enable mysqld &>> $log
systemctl restart mysqld &>> $log

echo -e "\e[32mResetting the MySQL root password.\e[0m" | tee -a $log
mysql_secure_installation --set-root-pass RoboShop@1 &>> $log