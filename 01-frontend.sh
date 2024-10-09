component=frontend
source ./component_setup.sh

echo -e "\e[1;36m--- Nginx Web Server Setup ---\e[0m" | tee -a $log

echo -e "\e[32mInstalling Nginx.\e[0m" | tee -a $log
dnf install nginx -y &>> $log
func_exit_status

echo -e "\e[32mRemoving default Nginx content.\e[0m" | tee -a $log
rm -rf /usr/share/nginx/html/* &>> $log
func_exit_status

echo -e "\e[32mDownloading the frontend web layer code.\e[0m" | tee -a $log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> $log
func_exit_status

echo -e "\e[32mExtracting the web layer code.\e[0m" | tee -a $log
unzip -o /tmp/frontend.zip -d /usr/share/nginx/html/ &>> $log
func_exit_status

echo -e "\e[32mConfiguring reverse proxy settings.\e[0m" | tee -a $log
cp config-files/1-reverse-proxy.conf /etc/nginx/default.d/reverse-proxy.conf &>> $log 
func_exit_status

echo -e "\e[32mRestarting and enabling the Nginx service.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log
systemctl enable nginx &>> $log
systemctl restart nginx &>> $log
func_exit_status
