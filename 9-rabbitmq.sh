component=rabbitmq
log="/tmp/$component.log"

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mAdding Erlang repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash >> $log

echo -e "\e[32mAdding RabbitMQ repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash >> $log

echo -e "\e[32mInstalling RabbitMQ server.\e[0m" | tee -a $log
dnf install rabbitmq-server -y >> $log

echo -e "\e[32mEnabling and restarting RabbitMQ service.\e[0m" | tee -a $log
systemctl restart rabbitmq-server >> $log
systemctl enable rabbitmq-server >> $log

echo -e "\e[32mAdding 'roboshop' user to RabbitMQ.\e[0m" | tee -a $log
rabbitmqctl add_user roboshop roboshop123 >> $log

echo -e "\e[32mSetting permissions for 'roboshop' user in RabbitMQ.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >> $log