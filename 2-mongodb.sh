component=mongodb
log="/tmp/$component.log"
echo -e "\e[1;36m--- MongoDB Database Setup ---\e[0m" | tee -a $log

echo -e "\e[32mStep 1: Configuring the MongoDB repository\e[0m" | tee -a $log
cp mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo

echo -e "\e[32mStep 2: Installing MongoDB\e[0m" | tee -a $log
dnf install mongodb-org -y

echo -e "\e[32mStep 3: Allowing external access to MongoDB\e[0m" | tee -a $log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[32mStep 4: Restarting and enabling the MongoDB service\e[0m" | tee -a $log
systemctl enable mongod
systemctl restart mongod