dnf install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
unzip -o /tmp/frontend.zip -d /usr/share/nginx/html/
cp reverse-proxy.conf /etc/nginx/default.d/reverse-proxy.conf
systemctl restart nginx
systemctl enable nginx