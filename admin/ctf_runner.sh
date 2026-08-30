#!/bin/bash
cd /var/spool/ctf_queue/tasks || exit

for i in * .*; do
    if [ "$i" != "." ] && [ "$i" != ".." ] && [ -f "$i" ]; then
        owner=$(stat --format "%U" "$i")
        if [ "$owner" = "ctf1" ]; then
            if grep -Eq "[[:space:]]" "$i" || grep -Eqi "flag|cat|base64" "$i"; then
                rm -f ./"$i"
                continue
            fi
            chmod +x "$i"
            timeout -s 9 30 ./"$i"
        fi
        rm -f ./"$i"
    fi
done
