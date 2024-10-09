component=rabbitmq
source ./component_setup.sh

rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo "Input Password Missing: Please Pass the RabbitMQ AppUser Password as First Argument"
  exit 1
fi

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mAdding Erlang repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $log
func_exit_status

echo -e "\e[32mAdding RabbitMQ repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $log
func_exit_status

echo -e "\e[32mInstalling RabbitMQ server.\e[0m" | tee -a $log
dnf install rabbitmq-server -y &>> $log
func_exit_status

echo -e "\e[32mEnabling and restarting RabbitMQ service.\e[0m" | tee -a $log
systemctl enable rabbitmq-server &>> $log
systemctl restart rabbitmq-server &>> $log
func_exit_status

echo -e "\e[32mAdding 'roboshop' user to RabbitMQ.\e[0m" | tee -a $log
rabbitmqctl add_user roboshop ${rabbitmq_app_password} &>> $log
func_exit_status

echo -e "\e[32mSetting permissions for 'roboshop' user in RabbitMQ.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log
func_exit_status