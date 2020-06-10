#!/bin/bash
# WARNING : wait till script finished running

sudo dnf update -y 

## general tools installation ##

# installing GUI tools
sudo dnf groupinstall -y gnome-desktop
sudo dnf install -y xorg*

# removing useless tools
sudo dnf remove -y initial-setup initial-setup-gui

# set persistent GUI
systemctl isolate graphical.target
systemctl set-default graphical.target

# installing tools
sudo dnf install -y device-mapper-persistent-data lvm2 nano firefox git

# set keyboard to french
sudo localectl set-keymap fr

## Gitlab runner installation ##

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

## docker installation ##

# to add docker repository
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# to add latest docker-ce version
dnf install docker-ce --nobest -y

# enabling and starting docker
systemctl start docker
systemctl enable docker


## installing pelican and gitlab ##

# install python 2

sudo dnf install python2 -y

# install pelican with python2

pip2 install pelican
pip2 install Markdown
pip2 install typogrify

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


reboot now