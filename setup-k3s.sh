#!/bin/bash

USAGE_MESSAGE="Usage: $0 <network-interface> <nameserver-for-resolv-conf> <postgres-version> <postgres-user> <postgres-password> <postgres-k3s-database-name>"

for i in "$1" "$2" "$3" "$4" "$5" "$6"; do
    if [ -z "$i" ]; then
        echo $USAGE_MESSAGE
        exit 1
    fi
done

NETWORK_INTERFACE="$1"
NAMESERVER_FOR_RESOLV_CONF="$2"
POSTGRES_VERSION="$3"
POSTGRES_USER="$4"
POSTGRES_PASSWORD="$5"
POSTGRES_K3S_DATABASE_NAME="$6"
CUSTOM_RESOLV_CONF="/etc/k3s-resolv.conf"
KUBE_CONFIG_MODE=644
POSTGRES_CONNECTION_STRING="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_K3S_DATABASE_NAME"

sudo dnf module enable postgresql:$POSTGRES_VERSION -y
sudo dnf -y install postgresql-server
sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
pushd /tmp || exit
sudo -u postgres psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD' SUPERUSER;"
sudo -u postgres createdb $POSTGRES_K3S_DATABASE_NAME -O $POSTGRES_USER
popd || exit

sudo tee /var/lib/pgsql/data/pg_hba.conf <<EOF
local   all             all                                     peer
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
EOF

sudo systemctl restart postgresql

sudo tee $CUSTOM_RESOLV_CONF <<EOF
nameserver $NAMESERVER_FOR_RESOLV_CONF
EOF

curl -sfL https://get.k3s.io | sh -s - \
  --write-kubeconfig-mode $KUBE_CONFIG_MODE \
  --resolv-conf $CUSTOM_RESOLV_CONF \
  --datastore-endpoint $POSTGRES_CONNECTION_STRING \
  --flannel-iface $NETWORK_INTERFACE
  
sudo systemctl status k3s