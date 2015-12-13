Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network("forwarded_port", guest: 5000, host: 5000)
  config.vm.network("forwarded_port", guest: 1080, host: 1080)
  config.vm.network("private_network", type: "dhcp")
  config.vm.synced_folder(".", "/vagrant", type: "nfs")
  config.vm.provision(
    "shell",
    path: "sysop/bootstrap",
    privileged: false,
    args: "/vagrant"
  )
end
