#!/usr/bin/with-contenv bashio

# 1. Récupération des infos dynamiques
BOX_ID=$(bashio::info.hostname)
SERVER_IP=$(bashio::config 'server_addr')
TOKEN=$(bashio::config 'auth_token')

bashio::log.info "Démarrage du tunnel pour la box : ${BOX_ID}"

# 2. Génération de la config temporaire
cat <<EOF > /tmp/frpc.toml
serverAddr = "${SERVER_IP}"
serverPort = 7000
# On envoie l'ID dans le champ user pour que le validateur Python le reçoive
user = "${BOX_ID}"

auth.method = "token"
auth.token = "${TOKEN}"

[[proxies]]
name = "web-access"
type = "http"
localIP = "127.0.0.1"
localPort = 8123
customDomains = ["${SERVER_IP}"]
EOF

# 3. Lancement
exec /usr/bin/frpc -c /tmp/frpc.toml
