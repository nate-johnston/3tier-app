echo "The package was installed!  Yay!" > /etc/wowza
cat /etc/wowza

/bin/cp -v /app/threetier/systemd-start-script /etc/systemd/system/threetier.service
echo "Systemctl: enabling threetier"
/bin/systemctl enable threetier.service
echo "Systemctl: starting threetier"
/bin/systemctl start threetier.service
sleep 5
echo "Systemctl: checking status of threetier"
/bin/systemctl status threetier.service

