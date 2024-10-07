dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

mkdir /app

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
unzip -o /tmp/cart.zip -d /app

npm install --prefix /app

useradd roboshop -c "Application User"

cp service-files/cart.service /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl restart cart
systemctl enable cart


