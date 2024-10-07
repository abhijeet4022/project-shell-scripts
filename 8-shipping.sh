component=shipping
log="/tmp/$component.log"

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mInstalling Maven.\e[0m" | tee -a $log
dnf install maven -y &>> $log

echo -e "\e[32mCreating application directory.\e[0m" | tee -a $log
mkdir /app &>> $log

echo -e "\e[32mCreating application user.\e[0m" | tee -a $log
useradd roboshop -c "Application User" &>> $log

echo -e "\e[32mDownloading the ${component} application code.\e[0m" | tee -a $log
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>> $log

echo -e "\e[32mExtracting the application code.\e[0m" | tee -a $log
unzip -o /tmp/shipping.zip -d /app &>> $log

echo -e "\e[32mBuilding the application using Maven.\e[0m" | tee -a $log
mvn clean package -f /app/pom.xml &>> $log

echo -e "\e[32mMoving the application JAR file.\e[0m" | tee -a $log
mv /app/target/shipping-1.0.jar /app/shipping.jar &>> $log

echo -e "\e[32mCopying the service file.\e[0m" | tee -a $log
cp service-files/shipping.service /etc/systemd/system/shipping.service &>> $log

echo -e "\e[32mReloading the systemd daemon.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log

echo -e "\e[32mEnabling and starting the shipping service.\e[0m" | tee -a $log
systemctl enable shipping &>> $log
systemctl start shipping &>> $log

echo -e "\e[32mInstalling MySQL.\e[0m" | tee -a $log
dnf install mysql -y &>> $log

echo -e "\e[32mLoading the schema into MySQL.\e[0m" | tee -a $log
mysql -h mysql.learntechnology.cloud -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $log