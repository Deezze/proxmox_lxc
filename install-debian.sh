# Verbindung Host -> LXC
pct enter <vmid>

# Dateien kopieren
pct push <vmid> <lokaler_dateipfad> <zielpfad_im_container>

pct pull <vmid> <Quellpfad_im_Container> <Zielpfad_auf_dem_Host>

# Basis installieren
apt update && apt upgrade -y
apt install ufw sudo

# User anlegen
adduser deezze
usermod -aG sudo deezze
mkdir -p /home/deezze/.ssh
chmod 700 /home/deezze/.ssh
nano /home/deezze/.ssh/authorized_keys
# → Public Key einfügen
chmod 600 /home/deezze/.ssh/authorized_keys
chown -R deezze:deezze /home/deezze/.ssh

# ssh abhärten
nano /etc/ssh/sshd_config
Port 28282
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowTcpForwarding no

# ssh.socket konfigurieren
systemctl edit ssh.socket
[Socket]
ListenStream=
ListenStream=28282

systemctl daemon-reload
systemctl restart ssh.socket

# UFW Firewall aktivieren
ufw allow 28282/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP intern'
ufw enable
