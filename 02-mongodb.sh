component=mongodb
source ./component_setup.sh

echo -e "\e[1;32m--- MongoDB Database Setup ---\e[0m" | tee -a $log

echo -e "\e[36mConfiguring the MongoDB repository.\e[0m" | tee -a $log
cp repository-files/mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo &>> $log
func_exit_status

echo -e "\e[36mInstalling MongoDB.\e[0m" | tee -a $log
dnf install mongodb-org -y &>> $log
func_exit_status

echo -e "\e[36mAllowing external access to MongoDB.\e[0m" | tee -a $log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $log
func_exit_status

echo -e "\e[36mRestarting and enabling the MongoDB service.\e[0m" | tee -a $log
systemctl enable mongod &>> $log
systemctl restart mongod &>>
func_exit_status