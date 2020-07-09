#!/bin/bash
# WARNING : wait till script finished running

sudo dnf update -y 

# installing GUI tools
sudo dnf groupinstall -y gnome-desktop
sudo dnf install -y xorg*

# removing useless tools
sudo dnf remove -y initial-setup initial-setup-gui

# set persistent GUI
systemctl isolate graphical.target
systemctl set-default graphical.target

# install few useful tools
sudo dnf install firefox git curl wget unzip -y

# installing kernel headers
sudo dnf install dkms binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers -y
sudo dnf install kernel-devel -y

# to download gitlab runner
# option "L" for location (this option will make curl redo the request on the new place if it was redirected)
# option "O" writes output to a local file named like the remote file we get 
# option "J" tells the -O, --remote-name option to use the server-specified Content-Disposition filename instead of extracting a filename from the URL.

sudo curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm

# to install it
sudo rpm -Uvh gitlab-runner_amd64.rpm

# download gitlab-runner binaries
# option "L" for location (this option will make curl redo the request on the new place if it was redirected)
sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

# to configure it
sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start

# Install requirements for Symfony
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module reset php -y
sudo dnf module enable php:remi-7.4 -y
sudo dnf install -y php php-bcmath php-cli php-curl php-zip php-sqlite3 php-mysqlnd php-xml php-mbstring php-json php-posix
wget https://getcomposer.org/download/1.9.0/composer.phar
mv composer.phar /usr/bin/composer
sudo chmod +x /usr/bin/composer

## installing gitlab ##

# install python 2
sudo dnf install python2 -y

# For system performance purposes, it is recommended to configure the kernel's swappiness setting to a low value like 10:
# swappiness means how much and often Linux Kernel will copy RAM contents to SWAP
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
cat /proc/sys/vm/swappiness

# Use the following commands to setup a hostname, gitlab, and an FQDN, gitlab.example.com, for the machine:

sudo hostnamectl set-hostname gitlab
cat <<EOF | sudo tee /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.0.1 gitlab.example.com gitlab
EOF

# install Epel YUM repo #

sudo dnf install -y epel-release
sudo dnf -y update

# Install required dependencies #

sudo dnf install -y curl openssh-server openssh-clients

# Setup the GitLab RPM repo and then install GitLab CE #

cd
# s option for "silent mode" - S for "show error"
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.example.com" dnf install -y gitlab-ce

# configure and set online Gitlab ressources
sudo gitlab-ctl reconfigure

# set keyboard to french
localectl set-keymap fr
# reboot to apply few parameters