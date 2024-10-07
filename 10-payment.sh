component=payment
log="/tmp/$component.log"

echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

echo -e "\e[32mInstalling Python 3.6, GCC (Compiler), and Python Development Build Tools.\e[0m" | tee -a $log
dnf install python36 gcc python3-devel -y &>> $log

echo -e "\e[32mCreating application directory.\e[0m" | tee -a $log
mkdir /app &>> $log

echo -e "\e[32mCreating application user.\e[0m" | tee -a $log
useradd roboshop -c "Application User" &>> $log

echo -e "\e[32mDownloading the payment application code.\e[0m" | tee -a $log
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>> $log

echo -e "\e[32mExtracting the payment application code.\e[0m" | tee -a $log
unzip -o /tmp/payment.zip -d /app &>> $log

echo -e "\e[32mInstalling the required Python dependencies.\e[0m" | tee -a $log
pip3.6 install -r /app/requirements.txt &>> $log

echo -e "\e[32mCopying the payment service file.\e[0m" | tee -a $log
cp service-files/payment.service /etc/systemd/system/payment.service &>> $log

echo -e "\e[32mReloading systemd and starting the payment service.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log
systemctl restart payment &>> $log
systemctl enable payment &>> $log