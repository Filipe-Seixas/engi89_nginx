# Updates the package list that may need upgrading
sudo apt-get update -y
# Fetch new versions of packages existing on the machine
sudo apt-get upgrade -y
# Installs nginx package
sudo apt-get install nginx -y
# Checks to see if nginx is running properly
systemctl status nginx
# updates nodejs package for upgrade
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
sudo npm install pm2 -g
cd app/
npm install -y
# Edits the default file for the correct proxy_pass
cd
cd /etc/nginx/sites-available
sudo rm -rf default
sudo echo "server{
        listen 80;
        server_name _;
        location / {
        proxy_pass http://192.168.10.100:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        }
}" >> default
# Restarts nginx
sudo systemctl restart nginx
sudo systemctl status nginx
# Reseeds the database
cd /home/vagrant/app
node seeds/seed.js
