#!/bin/bash
# add user git
sudo adduser --system --shell /bin/bash --gecos 'git version control' --group --disabled-password --home /home/git git
# add user gitlab
sudo adduser --disabled-login --gecos 'gitlab system' gitlab
# move user gitlab to group git
sudo usermod -a -G git gitlab
sudo usermod -a -G gitlab git
# generate key
sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa
# clone gitlab's fork to the gitolite source code
cd /home/git
sudo -H -u git git clone -b gl-v304 https://github.com/gitlabhq/gitolite.git /home/git/gitolite
# setup
cd /home/git
sudo -u git -H mkdir bin
sudo -u git sh -c 'echo -e "PATH=\$PATH:/home/git/bin\nexport PATH" >> /home/git/.profile'
sudo -u git sh -c 'gitolite/install -ln /home/git/bin'
sudo cp /home/gitlab/.ssh/id_rsa.pub /home/git/gitlab.pub
sudo chmod 0444 /home/git/gitlab.pub
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gitolite setup -pk /home/git/gitlab.pub"
# permissions
sudo chmod -R g+rwX /home/git/repositories/
sudo chown -R git:git /home/git/repositories/
sudo -u gitlab -H git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin

if [[ $? != 0 ]];then
    echo "error: gitolite is not installed correct, or the ssh key is not right"
    exit 1
fi

sudo rm -rf /tmp/gitolite-admin
# clone gitlab source and install prerequisites
sudo gem install charlock_holmes
sudo pip install pygments
cd /home/gitlab
sudo -H -u gitlab git clone git://github.com/51fanli/gitlabhq.git gitlab
cd gitlab
sudo -u gitlab cp config/gitlab.yml.example config/gitlab.yml
# mysql databases init
echo "connect to mysql"
mysql -h127.0.0.1 -uroot -p
# CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
# CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '123456';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';
sudo -u gitlab cp config/database.yml.example config/database.yml
sudo -u gitlab -H bundle install --without development test sqlite postgres --deployment
sudo -u gitlab -H git config --global user.email "gitlab@localhost"
sudo -u gitlab -H git config --global user.name "Gitlab"
sudo -u gitlab cp config/resque.yml.example config/resque.yml
sudo -u gitlab cp config/unicorn.rb.example config/unicorn.rb
# init tables
sudo -u gitlab bundle exec rake gitlab:app:setup RAILS_ENV=production
sudo cp ./lib/hooks/post-receive /home/git/.gitolite/hooks/common/post-receive
sudo chown git:git /home/git/.gitolite/hooks/common/post-receive
# check status
sudo -u gitlab bundle exec rake gitlab:app:status RAILS_ENV=production
sudo wget https://raw.github.com/gitlabhq/gitlab-recipes/master/init.d/gitlab -P /etc/init.d/
sudo chmod +x /etc/init.d/gitlab
sudo update-rc.d gitlab defaults 21
