# spool-cleaner

A scheduled cleanup task runs in the background to process automation jobs. Can you craft a script that bypasses the security sanity checks to escalate privileges and read the protected flag?

`difficulty: Medium` <br>
`author: ujjwal`

## Flag
EH4X{cr0n_sp00l_b4sh_0bfusc4t10n_0921}


## Overview

A Linux privilege escalation and command obfuscation challenge. Players log in via SSH with low-privilege access (`ctf1`). A cron job runs every minute as a higher-privilege user (`ctf2`), executing user-submitted scripts from `/var/spool/ctf_queue/tasks`. The execution runner filters out whitespaces and sensitive keywords (`cat`, `flag`, `base64`), requiring players to use bash parameter expansion (`$IFS`), character concatenation, and path globbing to exfiltrate the flag from `/etc/ctf_flags/flag`.

## Solution

1. Log into the host via SSH using credentials `ctf1:ctf1pass`.
2. Inspect the scheduled cron job in `/etc/cron.d/ctf_cron` and the runner script `/usr/bin/ctf_runner.sh`.
3. Notice that the runner executes scripts owned by `ctf1`, but rejects files containing whitespace (spaces/tabs) or blacklisted strings (`flag`, `cat`, `base64`).
4. Craft a payload script in `/tmp/` that:
   - Uses `#!/bin/bash` as the interpreter.
   - Bypasses whitespace filtering using the `$IFS` environment variable.
   - Bypasses keyword filters using quote concatenation (e.g., `c''a''t`) and directory globbing (`/etc/ctf_fl*/*`).
   - Dumps the flag contents into a world-writable destination (e.g., `/tmp/out`).
5. Copy the crafted script to `/var/spool/ctf_queue/tasks/`.
6. Wait for the 1-minute cron cycle to trigger, then read the extracted flag from `/tmp/out`.

## Resources
- Detailed writeup: `./solution/README.md`
- Solve script: `./solution/solve.sh`
