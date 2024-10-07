component=redis
log="/tmp/$component.log"

echo -e "\e[1;36m--- Redis Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mStep 1: Installing Remi repository for Redis\e[0m" | tee -a $log
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $log

echo -e "\e[32mStep 2: Enabling the Redis 6.2 module from Remi repository\e[0m" | tee -a $log
dnf module enable redis:remi-6.2 -y &>> $log

echo -e "\e[32mStep 3: Installing Redis\e[0m" | tee -a $log
dnf install redis -y &>> $log

echo -e "\e[32mStep 4: Configuring Redis to allow external access\e[0m" | tee -a $log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>> $log

echo -e "\e[32mStep 5: Enabling and restarting Redis service\e[0m" | tee -a $log
systemctl enable redis &>> $log
systemctl restart redis &>> $log