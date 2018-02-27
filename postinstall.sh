export PATH=$PATH:/usr/local/bin:/app/interpreters/ruby/1.9.3/bin
echo "The package was installed!  Yay!" > /etc/wowza
cat /etc/wowza
echo
echo "Installing bundler"
gem install bundler --no-ri --no-rdoc
echo
echo "Bundle Install"
cd /app/threerier
bundle install
/bin/cp -v /app/threetier/systemd-start-script /etc/systemd/system/threetier.service
echo "Systemctl: enabling threetier"
/bin/systemctl enable threetier.service
echo "Systemctl: starting threetier"
/bin/systemctl start threetier.service
sleep 5
echo "Systemctl: checking status of threetier"
/bin/systemctl status threetier.service

