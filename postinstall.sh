export PATH=$PATH:/usr/local/bin:/app/interpreters/ruby/1.9.3/bin
GEM=`/usr/bin/dpkg -L ruby | grep bin/gem | head -1`
echo "The package was installed!  Yay!" > /etc/wowza
cat /etc/wowza
echo
echo "Installing bundler..."
${GEM} install bundler 
echo
echo "Bundle Install..."
cd /app/threetier
BUNDLER_DIR="`${GEM} environment | grep 'EXECUTABLE DIRECTORY' | awk '{print $4}'`"
if [ -z "$BUNDLER_DIR" ]; then
    echo "Can not find bundler!"
    exit 1
fi
BUNDLER=${BUNDLER_DIR}/bundler
if [ ! -f $BUNDLER ]; then
    echo "No such file: $BUNDLER"
    exit 2
fi
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

