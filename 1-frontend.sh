echo -e "\e[1;36m--- Nginx Web Server Setup ---\e[0m"

echo -e "\e[32mStep 1: Installing Nginx\e[0m"
dnf install nginx -y

echo -e "\e[32mStep 2: Removing default Nginx content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[32mStep 3: Downloading the frontend web layer code\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[32mStep 4: Extracting the web layer code\e[0m"
unzip -o /tmp/frontend.zip -d /usr/share/nginx/html/

echo -e "\e[32mStep 5: Configuring reverse proxy settings\e[0m"
cp 1-reverse-proxy.conf /etc/nginx/default.d/reverse-proxy.conf

echo -e "\e[32mStep 6: Restarting and enabling the Nginx service\e[0m"
systemctl restart nginx
systemctl enable nginx
