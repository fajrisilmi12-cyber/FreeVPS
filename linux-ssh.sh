#!/bin/bash
# Pastikan variabel dari GitHub Actions terbaca (jika kamu pakai parameter $1 $3 $4, masukkan di sini)
# Tapi jika kamu set variabelnya langsung di ENV GitHub Actions, biarkan saja seperti ini.

echo "=== 1. Mengonfigurasi User & Hostname ==="
sudo useradd -m -s /bin/bash $LINUX_USERNAME
sudo adduser $LINUX_USERNAME sudo
echo "$LINUX_USERNAME:$LINUX_USER_PASSWORD" | sudo chpasswd

# FIX 1: Tambahkan sudo di depan sed agar tidak Permission Denied
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $LINUX_MACHINE_NAME

# FIX 2: Hierarki Sudo (Bypass Password)
echo "$LINUX_USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/99_$LINUX_USERNAME
sudo chmod 0440 /etc/sudoers.d/99_$LINUX_USERNAME

# FIX 3: Tambahkan perintah echo di baris ini
echo "=== 2. Menginstal Desktop XFCE (Ringan) & Google Chrome ==="
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y xfce4 xfce4-terminal dbus-x11 wget > /dev/null 2>&1

# Instal Chrome Browser di dalam VPS
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb > /dev/null 2>&1

echo "=== 3. Menginstal Chrome Remote Desktop ==="
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt-get install -y ./chrome-remote-desktop_current_amd64.deb > /dev/null 2>&1

# FIX 4: Pindahkan usermod ke SINI, setelah Chrome Remote Desktop selesai diinstal
sudo usermod -aG chrome-remote-desktop $LINUX_USERNAME || true

echo "=== 4. Setting Default Desktop ke XFCE ==="
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

# Mencegah error "Failed to read" dengan membuat foldernya lebih dulu
sudo -i -u $LINUX_USERNAME mkdir -p /home/$LINUX_USERNAME/.config/chrome-remote-desktop

echo "=== 5. Autentikasi Google Remote Desktop ==="
# ⚠️ PENTING: AMBIL KODE BARU DARI GOOGLE KARENA KODE DI BAWAH INI SUDAH HANGUS ⚠️
# Jangan lupa biarkan --pin=123456 di bagian paling akhir
sudo -i -u $LINUX_USERNAME bash -c 'DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0Aci98E-412dTI_yT54geRgNZCwSnN8YznsomE88py2PzOHpxrDSylY6YYrf70iUOhZ8LCQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname) --pin=123456'

echo "========================================================================"
echo "✅ BERHASIL! VPS Desktop kamu sudah online."
echo "Buka: https://remotedesktop.google.com/access di browser kamu."
echo "PIN kamu adalah: 123456"
echo "========================================================================"

echo "⏳ Menahan runner agar tetap hidup selama 6 jam..."
sleep 21600
