dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

mkdir /app

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
unzip -o /tmp/user.zip -d /app

npm install --prefix /app

useradd roboshop -c "Application User"

cp service-files/user.service /etc/systemd/system/user.service

systemctl daemon-reload
systemctl restart user
systemctl enable user

cp repository-files/mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo
dnf install -y mongodb-org-shell

mongo --host mongodb.learntechnology.cloud </app/schema/user.js

