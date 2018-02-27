export PATH=$PATH:/usr/local/bin:/app/interpreters/ruby/1.9.3/bin
GEM=`/usr/bin/dpkg -L ruby | grep bin/gem | head -1`
echo "The package was installed!  Yay!" > /etc/wowza
cat /etc/wowza
echo
echo "Installing bundler..."
${GEM} install bundler --no-ri --no-rdoc
echo
echo "Bundle Install..."
cd /app/threetier
BUNDLER="`${GEM} environment | grep 'EXECUTABLE DIRECTORY' | awk '{print $4}'`/bundler"
${BUNDLER} install
echo
echo "Setting up systemd..."
/bin/cp -v /app/threetier/systemd-start-script /etc/systemd/system/threetier.service
echo "Systemctl: enabling threetier"
/bin/systemctl enable threetier.service
echo "Systemctl: starting threetier"
/bin/systemctl start threetier.service
sleep 5
echo "Systemctl: checking status of threetier"
/bin/systemctl status threetier.service

