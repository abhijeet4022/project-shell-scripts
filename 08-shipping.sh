component="shipping"
schema_type="mysql"
source ./component_setup.sh
mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo "Root Password Missing: Please Pass the MySQL Root Password as First Argument"
  exit 1
fi


# Calling func_nodejs function to setup catalogue
func_java

