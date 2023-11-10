#!/bin/bash
sudo /usr/bin/apt update -y 
sudo /usr/bin/apt install -y postgresql
systemctl start postgresql
systemctl enable postgresql
sudo -u postgres psql -c "CREATE DATABASE mydatabase;"
sudo -u postgres psql -c "CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/*/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
systemctl restart postgresql   