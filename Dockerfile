# REQUIRED FILES TO BUILD THIS IMAGE
# ==================================
#
# From http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
# Download the following three files:
# - instantclient-basic-linux.x64-12.2.0.1.0.zip
# - instantclient-sqlplus-linux.x64-12.2.0.1.0.zip
# - instantclient-sdk-linux.x64-12.2.0.1.0.zip
# Place the files in the same folder as this Dockerfile

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip curl libaio1 libdbi-perl build-essential postgresql-client

COPY instantclient-*-linux.x64-12.2.0.1.0.zip /tmp/

RUN mkdir -p /opt/oracle && \
    unzip "/tmp/instantclient-*-linux.x64-12.2.0.1.0.zip" -d /opt/oracle && \
    rm -f /tmp/instantclient-*-linux.x64-12.2.0.1.0.zip

ENV ORACLE_HOME=/opt/oracle/instantclient_12_2
ENV LD_LIBRARY_PATH=${ORACLE_HOME}
ENV PATH=$ORACLE_HOME:${PATH}

RUN curl -sL -o /tmp/DBD-Oracle.tgz http://www.perl.org/CPAN/authors/id/P/PY/PYTHIAN/DBD-Oracle-1.74.tar.gz && \
    cd /tmp && tar -xf DBD-Oracle.tgz && rm -f DBD-Oracle.tgz && \
    cd DBD-Oracle* && perl Makefile.PL && make && make install && \
    curl -sL -o /tmp/ora2pg.tgz https://github.com/darold/ora2pg/archive/v19.1.tar.gz && \
    cd /tmp && tar xf ora2pg.tgz && rm -f ora2pg.tgz && \
    cd ora2pg* && perl Makefile.PL && make && make install
