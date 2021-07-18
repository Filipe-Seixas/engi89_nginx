# Setting up Development Env
## Instalattion of Vagrant, VirtualBox and Ruby
### Vagrant commands
- `vagrant up` to launch the vm
- `vagrant destroy` to delete everything
- `vagrant reload` to reload any new instruction in our `Vagrantfile`
- `vagrant halt` to pause the vm

#### More commands can be found by typing `vagrant` on gitbash terminal:
```Common commands:
     autocomplete    manages autocomplete installation on host
     box             manages boxes: installation, removal, etc.
     cloud           manages everything related to Vagrant Cloud
     destroy         stops and deletes all traces of the vagrant machine
     global-status   outputs status Vagrant environments for this user
     halt            stops the vagrant machine
     help            shows the help for a subcommand
     init            initializes a new Vagrant environment by creating a Vagrantfile
     login
     package         packages a running vagrant environment into a box
     plugin          manages plugins: install, uninstall, update, etc.
     port            displays information about guest port mappings
     powershell      connects to machine via powershell remoting
     provision       provisions the vagrant machine
     push            deploys code in this environment to a configured destination
     rdp             connects to machine via RDP
     reload          restarts vagrant machine, loads new Vagrantfile configuration
     resume          resume a suspended vagrant machine
     snapshot        manages snapshots: saving, restoring, etc.
     ssh             connects to machine via SSH
     ssh-config      outputs OpenSSH valid configuration to connect to the machine
     status          outputs status of the vagrant machine
     suspend         suspends the machine
     up              starts and provisions the vagrant environment
     upload          upload to machine via communicator
     validate        validates the Vagrantfile
     version         prints current and latest Vagrant version
     winrm           executes commands on a machine via WinRM
     winrm-config    outputs WinRM configuration to connect to the machine
```

- Let's `ssh` into our vm and launch nginx we-server
- use `apt-get` package manager in Linux - for mac `homebrew` or only `brew`
- `apt-get` is used to install any packages needed
- To use the command in admin mode we can use `sudo` before the command
- `sudo apt-get upgrade -y`
- `sudo apt-get update -y`
- `ping www.bbc.co.uk`
- `sudo apt-get install name_of_the_package`
- To work in an `admin mode` at all times (not recommended) `sudo -su`
- We will install nginx in our guest machine/VM
- Launch the default nginx page in host machine's browser
- install nginx `sudo apt-get install nginx -y`
- checking status of nginx `systemctl status nginx` or start `systemctl restart nginx` or restart `systemctl restart nginx`


<p align:center>
<img src="vagrant_diagram.png">
</p>


- Let's automate the tasks that we did manually earlier today
- Create a file called `provision.sh`
- `sudo apt-get update -y`
- `sudo apt-get upgrade -y`
- `sudo apt-get install ngnix`
- `systemctl status ngnix`


- To run provision.sh we need to give file permissions and make this file executable
- To change permission we use `chomod` with required permission then file name
- `chmod +x provision.sh`
- ./filename

## Vagrant Tests
- On Host machine, inside spec-tests folder:
     - `gem install bundler` to install bundler
     - `bundle` to run bundle and get dependencies
     - `rake spec` to run tests
- On VM:
     - `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -` and `sudo apt-get install nodejs` to install nodejs version 6
     - Run tests again on Host machine to see we've passed another test
     - `sudo apt-get install python-software-properties` to install all python dependencies
     - `sudo npm install pm2 -g` to pass second test by installing pm2, a process manager for Nodejs
     - Adding environment variables `export DB_HOST=mongodb`
     - To make env variables persistant use nano to write on .profile last line `export DB_HOST=mongodb`

## Start app
- Go into the app folder inside environment and run `sudo npm install`
- Run `node app.js` to start

## Automating Provision.sh
```sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
systemctl status nginx
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties -y
sudo npm install pm2 -g
sudo echo 'export DB_HOST=mongodb' >> .bashrc
cd environment/app/
npm install -y
npm start
npm run
```

## Nginx
- Create a default file in /etc/nginx/sites-available
```
server {
     listen 80;

     server_name _;

     location / {
         proxy_pass http://192.168.10.100:3000;
         proxy_http_version 1.1;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection 'upgrade';
         proxy_set_header Host $host;
         proxy_cache_bypass $http_upgrade;
     }
}

```
- sudo nginx -t to test syntax of file
- Go to app folder
- sudo systemctl restart nginx to restart nginx
- sudo systemctl status nginx to check status
- Go to browser on 192.168.10.100 and you should see the Sparta screen which was previously on 192.168.10.100:3000

## DB
- sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
- echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
- sudo apt-get update -y
- sudo apt-get upgrade -y
- sudo apt-get install mongodb-org=3.2.20 -y
- sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20
- Go to /etc/mongod.conf and change ip to 0.0.0.0
- sudo systemctl restart mongod
- sudo systemctl enable mongod

####From app:
- `source ~/.bashrc`
- npm start in app folder
- if posts are connecting but not showing, do node seeds/seed.js
- npm start

## Errors
- `, {useMongoClient:true}` on app.js when adding env variable
- if the environment variable isn't working, try adding `DB_HOST="${DB_HOST:-mongodb://192.168.10.101:27017/posts}"` to provision.sh
{"mode":"full","isActive":false}