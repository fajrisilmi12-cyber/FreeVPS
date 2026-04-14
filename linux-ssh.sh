#linux-run.sh LINUX_USER_PASSWORD NGROK_AUTH_TOKEN LINUX_USERNAME LINUX_MACHINE_NAME
#!/bin/bash
# /home/runner/.ngrok2/ngrok.yml

sudo useradd -m $LINUX_USERNAME
sudo adduser $LINUX_USERNAME sudo
echo "$LINUX_USERNAME:$LINUX_USER_PASSWORD" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $LINUX_MACHINE_NAME

- name: Start Pinggy Proxy untuk SSH
      run: |
        echo "Memulai Pinggy..."
        # Menjalankan Pinggy di background tanpa meminta konfirmasi host key
        nohup ssh -p 443 -R0:localhost:22 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 a.pinggy.io > pinggy_out.txt 2>&1 &
        
        # Jeda 5 detik agar Pinggy selesai melakukan tunneling
        sleep 5
        
        # Menampilkan output log agar Anda bisa melihat alamat dan port yang diberikan
        echo "=========================================="
        cat pinggy_out.txt
        echo "=========================================="

    - name: Keep Runner Alive
      run: |
        echo "Menahan runner agar tidak mati (tetap hidup selama 1 jam)..."
        # Runner di GitHub Actions akan langsung mati jika semua perintah selesai.
        # Perintah sleep ini berfungsi menahan runner agar Anda punya waktu untuk remote SSH.
        sleep 3600
