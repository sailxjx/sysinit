#!/bin/bash
sudo -i
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
# check
# su gitlab
# cd
# exec ssh-agent bash
# ssh-add ~/.ssh/id_gitlab_rsa
# git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin
# kill $SSH_AGENT_PID
# [[ $? != 0 ]] && echo 'permission denied!' && exit && exit
# echo 'check success!'
# rm -rf /tmp/gitolite-admin
# exit

# clone gitlab source and install prerequisites
gem install charlock_holmes --version '0.6.8'
pip install pygments
gem install bundler
cd /home/gitlab
sudo -H -u gitlab git clone git://github.com/51fanli/gitlabhq.git gitlab
cd gitlab
sudo -u gitlab cp config/gitlab.yml.example config/gitlab.yml
# mysql databases init
mysql -uroot -p
# CREATE DATABASE IF NOT EXISTS COMBAKgitlabhq_production DEFAULT CHARACTER SET COMBAKutf8 COLLATE COMBAKutf8_unicode_ci;
# CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '123456';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON COMBAKgitlabhq_production.* TO 'gitlab'@'localhost';
sudo -u gitlab cp config/database.yml.example config/database.yml
sudo -u gitlab -H bundle install --without development test --deployment
sudo -u gitlab bundle exec rake gitlab:app:setup RAILS_ENV=production
cp ./lib/hooks/post-receive /home/git/.gitolite/hooks/common/post-receive
chown git:git /home/git/.gitolite/hooks/common/post-receive
sudo -u gitlab bundle exec rake gitlab:app:status RAILS_ENV=production

