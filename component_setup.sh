log="/tmp/$component.log"


func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}


func_apppreq(){
    echo -e "\e[32mCreating the ${component} application service file.\e[0m" | tee -a $log
    cp service-files/${component}.service /etc/systemd/system/${component}.service &>> $log
    func_exit_status

    echo -e "\e[32mCreating the application user.\e[0m" | tee -a $log
    useradd roboshop -c "Application User" &>> $log
    func_exit_status

    echo -e "\e[32mRemoving the old ${component} application directory.\e[0m" | tee -a $log
    rm -rf /app &>> $log
    func_exit_status

    echo -e "\e[32mCreating the ${component} application directory.\e[0m" | tee -a $log
    mkdir /app &>> $log
    func_exit_status

    echo -e "\e[32mDownloading the ${component} application content code.\e[0m" | tee -a $log
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> $log
    func_exit_status

    echo -e "\e[32mExtracting the ${component} application code.\e[0m" | tee -a $log
    unzip -o /tmp/${component}.zip -d /app &>> $log
    func_exit_status
}


func_systemd(){
    echo -e "\e[32mEnabling and restarting the ${component} application service.\e[0m" | tee -a $log
    systemctl daemon-reload &>> $log
    systemctl enable ${component}.service &>> $log
    systemctl restart ${component}.service &>> $log
    func_exit_status
}


func_schema_setup(){
  if [ "${schema_type}" = "mongodb" ]; then
    echo -e "\e[32mConfiguring the MongoDB repository.\e[0m" | tee -a $log
    cp repository-files/mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo &>> $log
    func_exit_status

    echo -e "\e[32mInstalling MongoDB client to load the schema.\e[0m" | tee -a $log
    dnf install mongodb-org-shell -y &>> $log
    func_exit_status

    echo -e "\e[32mLoading the schema for the ${component} application.\e[0m" | tee -a $log
    mongo --host mongodb.learntechnology.cloud </app/schema/${component}.js &>> $log
    func_exit_status
  fi

  if [ "${schema_type}" = "mysql" ]; then
    echo -e "\e[32mInstalling MySQL.\e[0m" | tee -a $log
    dnf install mysql -y &>> $log
    func_exit_status

    echo -e "\e[32mLoading the schema into MySQL.\e[0m" | tee -a $log
    mysql -h mysql.learntechnology.cloud -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>> $log
    func_exit_status
  fi
}


func_nodejs(){
  echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

  echo -e "\e[32mDisabling the current Node.js module.\e[0m" | tee -a $log
  dnf module disable nodejs -y &>> $log
  func_exit_status

  echo -e "\e[32mEnabling the Node.js 18 module.\e[0m" | tee -a $log
  dnf module enable nodejs:18 -y &>> $log
  func_exit_status

  echo -e "\e[32mInstalling Node.js.\e[0m" | tee -a $log
  dnf install nodejs -y &>> $log
  func_exit_status

  # Calling func_apppreq function
  func_apppreq

  echo -e "\e[32mDownloading application dependencies from package.json.\e[0m" | tee -a $log
  npm install --prefix /app &>> $log
  func_exit_status

  # Calling func_schema_setup function
  func_schema_setup

  # Calling func_systemd function
  func_systemd
}


func_java(){
  echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

  echo -e "\e[32mInstalling Maven.\e[0m" | tee -a $log
  dnf install maven -y &>> $log
  func_exit_status

  # Calling func_apppreq function
  func_apppreq

  echo -e "\e[32mBuilding the application using Maven.\e[0m" | tee -a $log
  mvn clean package -f /app/pom.xml &>> $log
  func_exit_status

  echo -e "\e[32mMoving the application artifact file to /app.\e[0m" | tee -a $log
  mv /app/target/${component}-1.0.jar /app/${component}.jar &>> $log
  func_exit_status

  # Calling func_schema_setup function
  func_schema_setup
  # Calling func_systemd function
  func_systemd
}


func_python() {
  echo -e "\e[1;36m--- ${component} Application Setup ---\e[0m" | tee -a $log

  echo -e "\e[32mInstalling Python 3.6, GCC (Compiler), and Python Development Build Tools.\e[0m" | tee -a $log
  dnf install python36 gcc python3-devel -y &>> $log
  func_exit_status


  # Calling func_apppreq function
  func_apppreq
  sed -i "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service
  func_exit_status

  echo -e "\e[32mInstalling the required Python dependencies.\e[0m" | tee -a $log
  pip3.6 install -r /app/requirements.txt &>> $log
  func_exit_status

  # Calling func_systemd function
  func_systemd
}