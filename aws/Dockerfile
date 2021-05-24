FROM ubuntu:20.04
# valentin 21.05.2021

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
# install kubectl, terraform & some fancy stuff
RUN apt-get update \
    && apt-get install -y curl git postgresql-client telnet software-properties-common vim apt-transport-https gnupg2 python3-pip nmap \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    #&& echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.kubernetes.io kubernetes-xenial main" \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && apt-get install -y kubectl terraform


ENV PYTHONWARNINGS="ignore"
RUN pip3 install -U --trusted-host pypi.org  awscli
ENV PATH=$PATH:/root/.local/bin
# install eksctl, helm & istio
RUN curl -sL "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin \
    && curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod +x /tmp/get_helm.sh && /tmp/get_helm.sh \
    && rm -f /tmp/get_heml.sh \
    && helm repo add stable https://charts.helm.sh/stable \
    && curl -sL https://istio.io/downloadIstioctl | sh -

ENV PATH=$PATH:/root/.istioctl/bin

CMD ["/bin/bash"]
