# Writeup: spool-cleaner

### Initial Enumeration
Check scheduled jobs in `/etc/cron.d/`:
```bash
cat /etc/cron.d/ctf_cron
```
cron entry reveals:

* * * * * ctf2 /usr/bin/ctf_runner.sh >/dev/null 2>&1

Inspecting /usr/bin/ctf_runner.sh:

Bash
```
if grep -Eq "[[:space:]]" "$i" \vert{}\vert{} grep -Eqi "flag\vert{}cat\vert{}base64" "$i"; then
    rm -f ./"$i"
    continue
fi
chmod +x "$i"
timeout -s 9 30 ./"$i"
```

Vulnerability Analysis
1.The cron job runs as ctf2, who owns the protected flag /etc/ctf_flags/flag.

2.User ctf1 scripts in /var/spool/ctf_queue/tasks are executed automatically.

3.Filters block:
   i.[[:space:]]: Spaces and tabs.
   ii.flag|cat|base64: Direct utility/path references.

Filter Bypass
 i.Space Bypass: Use $IFS (Internal Field Separator).
 ii.Keyword Bypass: Use empty single quotes (c''a''t executes as cat).
 iii.Path Bypass: Wildcard globbing /etc/ctf_fl*/* points directly to /etc/ctf_flags/flag.

Exploitation
Run solve.sh
