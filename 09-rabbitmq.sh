component=rabbitmq
rabbitmq_user=roboshop
source ./component_setup.sh

rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo "Input Password Missing: Please Pass the RabbitMQ AppUser Password as First Argument"
  exit 1
fi

echo -e "\e[1;32m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[36mAdding Erlang repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $log
func_exit_status

echo -e "\e[36mAdding RabbitMQ repository.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $log
func_exit_status

echo -e "\e[36mInstalling RabbitMQ server.\e[0m" | tee -a $log
dnf install rabbitmq-server -y &>> $log
func_exit_status

echo -e "\e[36mEnabling and restarting RabbitMQ service.\e[0m" | tee -a $log
systemctl enable rabbitmq-server &>> $log
systemctl restart rabbitmq-server &>> $log
func_exit_status

echo -e "\e[36mAdding 'roboshop' user to RabbitMQ.\e[0m" | tee -a $log
# Check if the user exists
user_check=$(rabbitmqctl list_users | grep -w "$rabbitmq_user")
if [ -z "${user_check}" ]; then
  rabbitmqctl add_user ${rabbitmq_user} ${rabbitmq_app_password} &>> $log
fi
func_exit_status

echo -e "\e[36mSetting permissions for 'roboshop' user in RabbitMQ.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log
func_exit_status