#!/bin/bash
# add user git
adduser --system --shell /bin/bash --gecos 'git version control' --group --disabled-password --home /home/git git
# add user gitlab
adduser --disabled-login --gecos 'gitlab system' gitlab
# move user gitlab to group git
usermod -a -G git gitlab
# generate key
sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_gitlab_rsa
# clone gitlab's fork to the gitolite source code
cd /home/git
sudo -H -u git git clone -b gl-v304 https://github.com/gitlabhq/gitolite.git /home/git/gitolite
# setup
cd /home/git
sudo -u git -H mkdir bin
sudo -u git sh -c 'gitolite/install -ln /home/git/bin'
sudo cp /home/gitlab/.ssh/id_gitlab_rsa.pub /home/git/gitlab.pub
sudo chmod 0444 /home/git/gitlab.pub
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gitolite setup -pk /home/git/gitlab.pub"
sudo -u git -H sed -i 's/0077/0007/g' /home/git/.gitolite.rc
# permissions
sudo chmod -R g+rwX /home/git/repositories/
sudo chown -R git:git /home/git/repositories/
# clone gitlab source and install prerequisites
gem install charlock_holmes
pip install pygments
cd /home/gitlab
sudo -H -u gitlab git clone git://github.com/51fanli/gitlabhq.git gitlab
cd gitlab
sudo -u gitlab cp config/gitlab.yml.example config/gitlab.yml
# mysql databases init
# mysql -uroot -p
# CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
# CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '123456';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';
sudo -u gitlab cp config/database.yml.example config/database.yml
sudo -u gitlab -H bundle install --without development test --deployment
# init tables
sudo -u gitlab bundle exec rake gitlab:app:setup RAILS_ENV=production
cp ./lib/hooks/post-receive /home/git/.gitolite/hooks/common/post-receive
chown git:git /home/git/.gitolite/hooks/common/post-receive

