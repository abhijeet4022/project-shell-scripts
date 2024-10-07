dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
mkdir /app
unzip -o /tmp/catalogue -d /app
npm install --prefix /app
useradd roboshop -c "Application User"
cp catalogue.service /etc/systemd/system/catalogue.service
systemctl restart catalogue.service
systemctl enable catalogue.service
cp mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo
dnf install mongodb-org-shell -y
mongo --host mongodb.learntechnology.cloud </app/schema/catalogue.js