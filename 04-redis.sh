component=redis
source ./component_setup.sh

echo -e "\e[1;36m--- Redis Application Setup ---.\e[0m" | tee -a $log

echo -e "\e[32mInstalling Remi repository for Redis.\e[0m" | tee -a $log
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $log
func_exit_status

echo -e "\e[32mEnabling the Redis 6.2 module from Remi repository.\e[0m" | tee -a $log
dnf module enable redis:remi-6.2 -y &>> $log
func_exit_status

echo -e "\e[32mInstalling Redis.\e[0m" | tee -a $log
dnf install redis -y &>> $log
func_exit_status

echo -e "\e[32mConfiguring Redis to allow external access.\e[0m" | tee -a $log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>> $log
func_exit_status

echo -e "\e[32mEnabling and restarting Redis service.\e[0m" | tee -a $log
systemctl enable redis &>> $log
systemctl restart redis &>> $log
func_exit_status