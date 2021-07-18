!#bin/bash
# Updates the mongodb package so it can be upgraded
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 –recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# Updates the package list that may need upgrading
sudo apt-get update -y
# Fetch new versions of packages existing on the machine
sudo apt-get upgrade -y
# Installs mongodb package
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20 --allow-unauthenticated
# Changing the mongod.conf file with right bindIp
cd /etc
sudo rm -rf mongod.conf
sudo echo "
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 0.0.0.0
" >> mongod.conf
# Restarting mongodb
sudo systemctl restart mongod
sudo systemctl enable mongod
