component=user
log="/tmp/$component.log"

echo -e "\e[1;36m--- ${component} Application Setup ---.\e[0m" | tee -a $log

echo -e "\e[32mDisabling the current Node.js module.\e[0m" | tee -a $log
dnf module disable nodejs -y &>> $log

echo -e "\e[32mEnabling the Node.js 18 module.\e[0m" | tee -a $log
dnf module enable nodejs:18 -y &>> $log

echo -e "\e[32mInstalling Node.js.\e[0m" | tee -a $log
dnf install nodejs -y &>> $log

echo -e "\e[32mCreating the application directory.\e[0m" | tee -a $log
rm -rf /app &>> $log
mkdir /app &>> $log


echo -e "\e[32mDownloading the ${component} application content code.\e[0m" | tee -a $log
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>> $log

echo -e "\e[32mExtracting the application code.\e[0m" | tee -a $log
unzip -o /tmp/user.zip -d /app &>> $log

echo -e "\e[32mDownloading application dependencies from package.json.\e[0m" | tee -a $log
npm install --prefix /app &>> $log

echo -e "\e[32mCreating the application user.\e[0m" | tee -a $log
useradd roboshop -c "Application User" &>> $log

echo -e "\e[32mCreating the application service file.\e[0m" | tee -a $log
cp service-files/user.service /etc/systemd/system/user.service &>> $log

echo -e "\e[32mEnabling and restarting the application service.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log
systemctl restart user &>> $log
systemctl enable user &>> $log

echo -e "\e[32mConfiguring the MongoDB repository.\e[0m" | tee -a $log
cp repository-files/mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo &>> $log

echo -e "\e[32mInstalling MongoDB client to load the schema.\e[0m" | tee -a $log
dnf install -y mongodb-org-shell &>> $log

echo -e "\e[32mLoading the schema for the application.\e[0m" | tee -a $log
mongo --host mongodb.learntechnology.cloud </app/schema/user.js &>> $log

