FROM rhelubi9:devbase

ADD scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*
#RUN cp /root/.bashrc /root/.bashrc.bak
#RUN echo "# Initial WSL default user setup script" >> /root/.bashrc
#RUN echo ". /usr/local/bin/wsl-user-setup.sh" >> /root/.bashrc
