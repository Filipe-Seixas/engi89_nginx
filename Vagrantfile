# Check to see if env is set, if not sets a new env
def set_env vars
  command = <<~HEREDOC
      echo "Setting Environment Variables"
      source ~/.bashrc
  HEREDOC

  vars.each do |key, value|
    command += <<~HEREDOC
      if [ -z "$#{key}" ]; then
          echo "export #{key}=#{value}" >> ~/.bashrc
      fi
    HEREDOC
  end

  return command
end

Vagrant.configure("2") do |config|

  # Define db 
  config.vm.define "db" do |db|
    # Define box we're using
    db.vm.box = "ubuntu/xenial64"
    # Set network and IP
    db.vm.network "private_network", ip: "192.168.10.150"
    # Run provision
    db.vm.provision "shell", path: "provisiondb.sh"
  end

  # Define app
  config.vm.define "app" do |app|
    # Define box we're using
    app.vm.box = "ubuntu/xenial64"
    # Define folders to be synced to box
    app.vm.synced_folder "environment", "/home/vagrant/env"
    app.vm.synced_folder "app", "/home/vagrant/app"
    # Set network and IP
    app.vm.network "private_network", ip: "192.168.10.100"
    # Run provision and call set_env function
    app.vm.provision "shell", path: "provision.sh"
    app.vm.provision "shell", inline: set_env({ DB_HOST: "mongodb://192.168.10.150:27017/posts" }), privileged: false
  end

end
