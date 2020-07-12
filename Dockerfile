FROM ernyoke/oracle-java8:latest

RUN apt-get update && \
    apt-get install -y wget pwgen expect && \
    apt-get install -y vim && \
    apt-get install -y dos2unix && \
    wget http://download.oracle.com/glassfish/5.0.1/release/glassfish-5.0.1.zip && \
    unzip glassfish-5.0.1.zip -d /opt && \
    rm glassfish-5.0.1.zip

ENV PATH /opt/glassfish5/bin:/opt/app/bin:$PATH
ENV GLASSFISH_PASS admin

RUN mkdir -p /opt/app/bin
RUN mkdir -p /opt/app/deploy

ADD bin/change_admin_password.sh /opt/app/bin/change_admin_password.sh
ADD bin/change_admin_password_func.sh /opt/app/bin/change_admin_password_func.sh
ADD bin/enable_secure_admin.sh /opt/app/bin/enable_secure_admin.sh
ADD bin/initialize-glassfish.sh /opt/app/bin/initialize-glassfish.sh
ADD bin/configure-glassfish.sh /opt/app/bin/configure-glassfish.sh
ADD bin/start-glassfish.sh /opt/app/bin/start-glassfish.sh
RUN chmod +x /opt/app/bin/*.sh

RUN dos2unix /opt/app/bin/*

RUN /opt/app/bin/initialize-glassfish.sh

RUN echo 'root:root' | chpasswd

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 4848 (administration), 8080 (HTTP listener), 8181 (HTTPS listener), 9009 (JPDA debug port)
EXPOSE 4848 8080 8181 9009

CMD ["/opt/app/bin/start-glassfish.sh"]

