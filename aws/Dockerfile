FROM ubuntu:22.10 
# valentin 02.12.2022
LABEL org.aseno.image.authors="valentin@aseno.de"

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata groff less jq bsdmainutils
# install kubectl, terraform & some fancy stuff
RUN apt-get update \
    && apt-get install -y curl git postgresql-client telnet software-properties-common vim ca-certificates apt-transport-https gnupg2 python3-pip nmap \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-add-repository "deb  https://packages.cloud.google.com/apt cloud-sdk main" \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.kubernetes.io kubernetes-xenial main" \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && apt-get install -y kubectl terraform google-cloud-sdk

COPY .bashrc /root/.bashrc
ENV PYTHONWARNINGS="ignore"
RUN pip3 install -U --trusted-host pypi.org  awscli
ENV PATH=$PATH:/root/.local/bin

# install eksctl, helm & istio
RUN curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin \
    && curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x /tmp/get_helm.sh && /tmp/get_helm.sh \
    && rm -f /tmp/get_heml.sh \
    && helm repo add stable https://charts.helm.sh/stable \
    && curl -sL https://istio.io/downloadIstioctl | sh -

ENV PATH=$PATH:/root/.istioctl/bin

CMD ["/bin/bash"]
