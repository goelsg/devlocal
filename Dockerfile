# we will use openjdk 8 with alpine as it is a very small linux distro
FROM amazonlinux:latest
#FROM ubuntu:latest

#user config
RUN who

# Variables.
WORKDIR /
ENV LD_BIND_NOW 1
ARG configs=./files/*
ARG startScript=./aws_commands.sh
ARG aws=./.aws
ARG vault=./vault

# INSTALL JAVA
# ==============================================================
# Setup the openjdk 8 repo
##RUN add-apt-repository ppa:openjdk-r/ppa

# Install java8
#RUN apt-get update && apt-get install openjdk-8-jdk -y --allow-change-held-packages

# Setup JAVA_HOME and other environment variables, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH $PATH:$JAVA_HOME/bin

#Some Commands
RUN yum repolist all
RUN yum clean all
RUN echo "sslverify=false" >> /etc/yum.conf  && yum update -y
RUN yum install yum-utils -y
RUN yum install curl -y
RUN yum-config-manager --save --setopt=AmazonCorretto.skip_if_unavailable=true
RUN amazon-linux-extras enable corretto8
RUN yum install java-1.8.0-amazon-corretto -y
RUN yum install java-1.8.0-amazon-corretto-devel -y
RUN java -version
RUN echo $JAVA_HOME
RUN yum install python3 -y
RUN yum install python -y
RUN echo python --version
RUN echo python3 --version
RUN yum install git -y
RUN yum install libmpc-devel mpfr-devel gmp-devel -y
RUN yum install libstdc++ -y 
RUN yum install tomcat-native -y

ENV LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH \
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.29-r0 \
    LANG=C.UTF-8 \
    IGNORE_CHECKSUM=false

RUN echo "Asia/Kolkata" > /etc/timezone


## Required Softwared or Tools
RUN amazon-linux-extras install docker
RUN yum install docker -y
RUN systemctl enable docker
#RUN service docker start
#RUN usermod -a -G docker ec2-user
RUN curl -O http://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py --user
RUN python get-pip.py --user
RUN export PATH=LOCAL_PATH:$PATH
RUN yum -y install python-pip
RUN yum -y install awscli
RUN yum install unzip -y
#RUN pip install awsebcli --upgrade --user --trusted-host pypi.org --trusted-host files.pythonhosted.org
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && aws --version
RUN git clone https://github.com/localstack/localstack.git
#python -m pip install -r requirements.txt --user --trusted-host pypi.org --trusted-host files.pythonhosted.org &&
RUN pwd
RUN ls -latr
RUN ls -latr /localstack
RUN python3 -m pip config debug
#RUN cat $HOME/.config/pip/pip.conf

###REDIS
RUN cd /usr/local/src 
RUN yum install wget -y
RUN yum install make -y
RUN wget http://download.redis.io/redis-stable.tar.gz
RUN tar xvzf redis-stable.tar.gz
RUN rm -f redis-stable.tar.gz
RUN cd redis-stable
RUN yum groupinstall "Development Tools" -y
RUN make distclean
RUN make
RUN yum install -y tcl

##### VAULT
RUN yum install vault -y
RUN COPY ${vault} ./

###LOCAL-STACK
RUN python3 --version
RUN python3 -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org flask
RUN python3 -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pip wheel setuptools>=46.1.0
RUN python3 -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --user -r /localstack/requirements.txt
RUN python3 -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org config --user localstack config --global http.sslVerify false
RUN yum -y install gcc make # install GCC compiler


########3FILES
RUN mkdir -p configs && COPY ${configs} /configs/
RUN mkdir -p startScript && COPY ${startScript} /startScript/
RUN COPY ${aws} .
RUN COPY ${aws} ~/
#Ls Command
RUN ln -fs app.jar 
RUN ls -latr ./

# set the startup command to execute the jar
#EXPOSE 9443
#ENTRYPOINT ["java","-jar","/app.jar"]
#CMD ["java","-jar","/app.war"]
#ENTRYPOINT ["java","-cp","app:app/lib/*","app.Application"]
ENTRYPOINT ["/bin/bash", "/startScript/aws_commands.sh"]