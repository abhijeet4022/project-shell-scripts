component=cart
log="/tmp/$component.log"

echo -e "\e[1;36m--- Cart Application Setup ---.\e[0m" | tee -a $log

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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>> $log

echo -e "\e[32mExtracting the application code.\e[0m" | tee -a $log
unzip -o /tmp/cart.zip -d /app &>> $log

echo -e "\e[32mDownloading application dependencies from package.json.\e[0m" | tee -a $log
npm install --prefix /app &>> $log

echo -e "\e[32mCreating the application user.\e[0m" | tee -a $log
useradd roboshop -c "Application User" &>> $log

echo -e "\e[32mCreating the application service file.\e[0m" | tee -a $log
cp service-files/cart.service /etc/systemd/system/cart.service &>> $log

echo -e "\e[32mEnabling and restarting the application service.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log
systemctl restart cart &>> $log
systemctl enable cart &>> $log


