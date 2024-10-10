FROM ubuntu:24.04
ENV ANSIBLE_VERSION=10.4.0
RUN apt update; \
    apt install -y gnupg2; \
    apt install -y pipx
ARG USERNAME=ansible
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV HOME=/home/$USERNAME
RUN groupadd --gid $USER_GID $USERNAME; \
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    mkdir -p /etc/$USERNAME && mkdir -p /home/$USERNAME/.ansible && chown -R $USERNAME:$USERNAME home/$USERNAME/
    #echo $USERNAME ALL=\(root\) NOPASSWD:ALL >/etc/sudoers.d/$USERNAME; \
    #chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR $HOME
ENV PATH="/$HOME/.local/bin:$PATH"
RUN pipx install --include-deps ansible==${ANSIBLE_VERSION}; \
    pipx install --include-deps py-passbolt
RUN pipx ensurepath --force
#RUN ansible-galaxy collection install anatomicjc.passbolt
#CMD ansible-playbook --version