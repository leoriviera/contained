FROM ubuntu:latest

ARG BLOG_GITHUB_REPO=https://github.com/leoriviera/blog
ENV BLOG_GITHUB_REPO=$BLOG_GITHUB_REPO

# Ignore Watchtower updates
LABEL com.centurylinklabs.watchtower.enable="false"

# Install packages
RUN apt update && apt install openssh-server sudo curl unzip sl rsync neofetch moreutils gettext-base -y

# Create a user "sshuser" and group "sshgroup"
RUN groupadd usergroup && useradd -ms /bin/bash -g usergroup user

# Disable SSH password
# https://stackoverflow.com/a/68968935
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN passwd -d user

# Install Starship shell
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y
RUN echo 'eval "$(starship init bash)"' >> /home/user/.bashrc

COPY --chown=root etc /tmp-etc
RUN chmod 755 -R /tmp-etc/*
# As env vars aren't available in update-motd.d, replace env vars in etc/ files with envsubst
# Requires sponge from moreutils (see https://stackoverflow.com/a/74551579)
RUN find /tmp-etc -type f -exec sh -c "cat {} | envsubst | sponge {}" \;

# Remove existing message of the day
RUN rm /etc/update-motd.d/*

# Copy-merge etc/ files to image
RUN rsync -av /tmp-etc/ /etc/

# Copy files to the user's home
COPY --chown=user home /home/user

# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22

CMD timeout 3600 /usr/sbin/sshd -D
