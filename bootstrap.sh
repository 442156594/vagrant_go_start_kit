# might not need sudo here if you run this as privileged in Vagrantfile
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo "Running apt-get update"
apt-get -y update >/dev/null 2>&1

install 'Development tools' build-essential

install Git git
install SQLite sqlite3 libsqlite3-dev
install wkhtmltopdf wkhtmltopdf
install Vim vim
install Zip zip

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'vagrant'@'localhost';
SQL

install 'NodeJS' nodejs
ln -s /usr/bin/nodejs /usr/sbin/node
install 'NPM' npm
echo "Installing Gulp"
npm install --global gulp-cli >/dev/null 2>&1


echo "install Go"
echo "Downloading Go"
curl --silent https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz > /tmp/go.tar.gz
echo "Extracting Go"
tar -xvzf /tmp/go.tar.gz --directory /usr/local >/dev/null 2>&1
install Mercurial mercurial

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/vagrant/gopath
export GOROOT=/usr/local/go
echo 'export GOPATH="/home/vagrant/gopath"' >> /home/vagrant/.bashrc
echo 'export GOROOT=/usr/local/go' >> /home/vagrant/.bashrc
echo 'export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:/home/vagrant/"' >> /home/vagrant/.bashrc

echo 'Downloading protoc'
wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
echo "Extracting protoc"
unzip protoc-3.2.0-osx-x86_64.zip

echo "Getting go package"
go get -u github.com/labstack/echo
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
go get google.golang.org/grpc
go get -u github.com/sunisdown/gqs

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'ALl done'

