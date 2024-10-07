cp mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo
dnf install mongodb-org -y
sed -i 's/127.0.0.0/0.0.0.0/' /etc/mongodb.conf
systemctl enable mongod
systemctl restart mongod