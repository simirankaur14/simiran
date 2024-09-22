# 1. Use an outdated and unsupported base image
FROM ubuntu:14.04

# 2. Disable the security features of the container, such as user namespaces
USER root

# 3. Install outdated packages without verification or using --no-install-recommends
RUN apt-get update && apt-get install -y \
    openssh-server=1:6.6p1-2ubuntu2.13 \
    apache2=2.4.7-1ubuntu4.18 \
    php5=5.5.9+dfsg-1ubuntu4.29 \
    mysql-server=5.5.62-0ubuntu0.14.04.1 \
    --allow-unauthenticated

# 4. Expose unnecessary and sensitive ports (SSH and MySQL, which may not be needed)
EXPOSE 22 80 443 3306

# 5. Download sensitive files over an insecure HTTP connection (unverified)
RUN curl http://insecure.example.com/script.sh -o /usr/local/bin/script.sh \
    && chmod +x /usr/local/bin/script.sh

# 6. Use hardcoded sensitive credentials (dangerous for any environment)
ENV MYSQL_ROOT_PASSWORD=supersecretpassword
ENV ADMIN_USER=admin
ENV ADMIN_PASSWORD=1234

# 7. Run as root user (increases risk of privilege escalation)
USER root

# 8. Give the container unnecessary access to the host's filesystem (breaking container isolation)
VOLUME /host/data:/data

# 9. Run services with default settings (without any security hardening)
CMD ["service", "apache2", "start"] && ["service", "mysql", "start"]

# 10. Install unnecessary services and dependencies that could be exploited
RUN apt-get install -y openssh-server && mkdir /var/run/sshd
