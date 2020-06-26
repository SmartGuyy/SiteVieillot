#!/bin/bash
# WARNING : wait till script finished running

apt-get update
apt upgrade -y
apt install curl wget unzip -y
# Install Gitlab
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
apt-get install gitlab-runner -y
# Install requirements for Symfony
apt install -y php php-bcmath php-cli php-curl php-zip php-sqlite3 php-mysql php-xml php-mbstring php-intl
wget https://getcomposer.org/composer-stable.phar
mv composer-stable.phar /usr/bin/composer
chmod +x /usr/bin/composer