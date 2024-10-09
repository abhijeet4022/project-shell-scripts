component=mysql
source ./component_setup.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo "Input Password Missing: Please Pass the MySQL Root Password as First Argument"
  exit 1
fi

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mDisabling the current MySQL module.\e[0m" | tee -a $log
dnf module disable mysql -y &>> $log
func_exit_status

echo -e "\e[32mConfiguring the ${component} repository.\e[0m" | tee -a $log
cp repository-files/mysql.repo /etc/yum.repos.d/mysql.repo &>> $log
func_exit_status

echo -e "\e[32mInstalling MySQL Community Server.\e[0m" | tee -a $log
dnf install mysql-community-server -y &>> $log
func_exit_status

echo -e "\e[32mEnabling and starting the mysqld service.\e[0m" | tee -a $log
systemctl enable mysqld &>> $log
systemctl restart mysqld &>> $log
func_exit_status

echo -e "\e[32mResetting the MySQL root password.\e[0m" | tee -a $log
mysql_secure_installation --set-root-pass ${mysql_root_password} &>> $log
func_exit_status