component="payment"
source ./component_setup.sh

rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo "Input RabbitMQ AppUser Password Missing: Please pass the rabbitmq user password."
  exit 1
fi

# Calling func_nodejs function to setup catalogue
func_python


