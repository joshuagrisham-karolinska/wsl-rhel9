FROM registry.access.redhat.com/ubi9/ubi:9.2-755.1697625012

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

RUN dnf update -y \
        && \
    dnf install -y \
        dnf-plugins-core \
        procps-ng \
        net-tools \
        iproute \
        git \
        wget \
        man \
        passwd \
        sudo \
        && \
    dnf clean all -y

# Add SITHS e-id CAs per https://inera.atlassian.net/wiki/spaces/IAM/pages/289082989/PKI-struktur+och+rotcertifikat
ADD http://aia.siths.se/sithseidrootcav2.cer /cacerts/
ADD http://aia.siths.se/sithseidfunctioncav1.cer /cacerts/

# Add Region Stockholm CAs per http://pki.regionstockholm.se
ADD http://pki.regionstockholm.se/aia/RsaRotCAv3.cer /cacerts/
ADD http://pki.regionstockholm.se/aia/RSRSACA01L3v3.cer /cacerts/
ADD http://pki.regionstockholm.se/aia/RSRSACA02L2v3.cer /cacerts/
ADD http://pki.regionstockholm.se/aia/RSRSACA03L2v3.cer /cacerts/
ADD http://pki.regionstockholm.se/aia/RSRSACA04l3v3.cer /cacerts/

# Update Trusted CAs
RUN for cer in /cacerts/*.cer; do openssl x509 -in $cer -outform PEM -out ${cer}.crt; done;
RUN mkdir -p /usr/share/pki/ca-trust-source/anchors/ && cp /cacerts/*.crt /usr/share/pki/ca-trust-source/anchors/
RUN update-ca-trust
