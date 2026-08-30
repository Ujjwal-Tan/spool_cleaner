FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    cron \
    sudo \
    coreutils \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ctf1 && \
    echo "ctf1:ctf1pass" | chpasswd && \
    useradd -m -s /bin/bash ctf2 && \
    echo "ctf2:$(openssl rand -base64 16)" | chpasswd

RUN mkdir -p /etc/ctf_flags && \
    echo "EH4X{cr0n_sp00l_b4sh_0bfusc4t10n_0921}" > /etc/ctf_flags/flag && \
    chown ctf2:ctf2 /etc/ctf_flags/flag && \
    chmod 400 /etc/ctf_flags/flag && \
    chmod 755 /etc/ctf_flags

RUN mkdir -p /var/spool/ctf_queue/tasks && \
    chmod 1777 /var/spool/ctf_queue/tasks

COPY ctf_runner.sh /usr/bin/ctf_runner.sh
RUN chmod 755 /usr/bin/ctf_runner.sh

COPY ctf_cron /etc/cron.d/ctf_cron
RUN chmod 0644 /etc/cron.d/ctf_cron && chown root:root /etc/cron.d/ctf_cron

RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 2220
CMD ["/entrypoint.sh"]
