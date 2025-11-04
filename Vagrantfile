puts ">>> Loaded Vagrantfile from: #{__dir__}"
Vagrant.configure("2") do |config|
  config.vm.define "k3s-node" do |node|
    node.vm.box = "ubuntu/jammy64"
    node.vm.box_version = "20241002.0.0"

    node.vm.hostname = "k3s-node"
    node.vm.network "private_network", ip: "192.168.56.11"

    node.vm.provider "virtualbox" do |vb|
      vb.name = "k3s-node"
      vb.memory = 4096
      vb.cpus = 2
    end

    node.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get upgrade -y
      sudo apt-get install -y python3
    SHELL
  end
end
