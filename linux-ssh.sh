#linux-run.sh LINUX_USER_PASSWORD NGROK_AUTH_TOKEN LINUX_USERNAME LINUX_MACHINE_NAME
#!/bin/bash
# /home/runner/.ngrok2/ngrok.yml

sudo useradd -m $LINUX_USERNAME
sudo adduser $LINUX_USERNAME sudo
echo "$LINUX_USERNAME:$LINUX_USER_PASSWORD" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $LINUX_MACHINE_NAME
sudo usermod -aG chrome-remote-desktop $LINUX_USERNAME || true

# 🌟 FIX BARU: Memberikan hak sudo tanpa password untuk user ini
echo "$LINUX_USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers"
=== 2. Menginstal Desktop XFCE (Ringan) & Google Chrome ==="
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y xfce4 xfce4-terminal dbus-x11 wget > /dev/null 2>&1
# Instal Chrome Browser di dalam VPS
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb > /dev/null 2>&1

echo "=== 3. Menginstal Chrome Remote Desktop ==="
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt-get install -y ./chrome-remote-desktop_current_amd64.deb > /dev/null 2>&1

echo "=== 4. Setting Default Desktop ke XFCE ==="
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
# Mencegah error "Failed to read" dengan membuat foldernya lebih dulu
sudo su - $LINUX_USERNAME -c 'mkdir -p ~/.config/chrome-remote-desktop'
echo "=== 5. Autentikasi Google Remote Desktop ==="
# ⚠️ PENTING: PASTE KODE DARI GOOGLE DI BAWAH INI ⚠️
# Jangan lupa tambahkan --pin=123456 di bagian paling akhir agar tidak nyangkut minta PIN

sudo su - $LINUX_USERNAME -c 'DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0Aci98E-412dTI_yT54geRgNZCwSnN8YznsomE88py2PzOHpxrDSylY6YYrf70iUOhZ8LCQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname) --pin=123456'


echo "========================================================================"
echo "✅ BERHASIL! VPS Desktop kamu sudah online."
echo "Buka: https://remotedesktop.google.com/access di browser kamu."
echo "PIN kamu adalah: 123456"
echo "========================================================================"

echo "⏳ Menahan runner agar tetap hidup selama 6 jam..."
sleep 21600
