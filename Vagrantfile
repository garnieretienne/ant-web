$script = <<EOF

# Configure the package manager
export DEBIAN_FRONTEND=noninteractive
sudo apt-get --quiet update

# Install rbenv dependencies
sudo apt-get --quiet --assume-yes install git build-essential

# Install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install rbenv plugin: rvm-download
git clone https://github.com/garnieretienne/rvm-download.git \
    ~/.rbenv/plugins/rvm-download

# Install rbenv plugin: rbenv-gem-rehash
git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
    ~/.rbenv/plugins/rbenv-gem-rehash

# Install rbenv plugin: rbenv-binstubs
git clone https://github.com/ianheggie/rbenv-binstubs.git \
    ~/.rbenv/plugins/rbenv-binstubs

# Install Ruby
ruby_version="2.2.1"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv download $ruby_version
rbenv global $ruby_version
rbenv rehash

# Install Bundler
gem install bundler

# Install Ruby on Rails dependencies
sudo apt-get --quiet --assume-yes install zlib1g-dev

# Install App system dependencies
sudo apt-get install --quiet --assume-yes libsqlite3-dev

# Install App gem dependencies
cd /vagrant && bundle install --path vendor/bundle --binstubs .bundle/bin

EOF

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provision "shell", inline: $script, privileged: false
end
