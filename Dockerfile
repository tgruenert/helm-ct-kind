# FROM alpine:3.13

# kubernetes in docker at Kubernetes reference to https://d2iq.com/blog/running-kind-inside-a-kubernetes-cluster-for-continuous-integration
# Linting from https://github.com/helm/chart-testing 
#
# run local with
# docker run -ti --rm --privileged jieyu/kind-cluster-buster:v0.1.0 /bin/bash
FROM jieyu/kind-cluster-buster:v0.1.0

RUN apt-get update && apt-get install -y \
    git \
    libc6 \
    openssh-client \
    python3-pip  \
    python3-wheel \
    python3 
RUN pip3 install --upgrade pip==21.0.1

# Install a YAML Linter
ARG yamllint_version=1.26.0
LABEL yamllint_version=$yamllint_version
RUN pip install "yamllint==$yamllint_version"

# Install Yamale YAML schema validator
ARG yamale_version=3.0.4
LABEL yamale_version=$yamale_version
RUN pip install "yamale==$yamale_version"

# Install kubectl
# ARG kubectl_version=v1.20.2
# LABEL kubectl_version=$kubectl_version
# RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl" && \
#     chmod +x kubectl && \
#     mv kubectl /usr/local/bin/

# Install Helm
ARG helm_version=v3.5.1
LABEL helm_version=$helm_version
RUN curl -LO "https://get.helm.sh/helm-$helm_version-linux-amd64.tar.gz" && \
    mkdir -p "/usr/local/helm-$helm_version" && \
    tar -xzf "helm-$helm_version-linux-amd64.tar.gz" -C "/usr/local/helm-$helm_version" && \
    ln -s "/usr/local/helm-$helm_version/linux-amd64/helm" /usr/local/bin/helm && \
    rm -f "helm-$helm_version-linux-amd64.tar.gz"

# Install ct
ARG ct_version=3.3.1
LABEL ct_version=$ct_version
RUN curl -LO "https://github.com/helm/chart-testing/releases/download/v${ct_version}/chart-testing_${ct_version}_linux_amd64.tar.gz" && \
    mkdir -p "/usr/local/ct-${ct_version}" && \
    tar -xzf "chart-testing_${ct_version}_linux_amd64.tar.gz" -C "/usr/local/ct-${ct_version}" && \
    ln -s "/usr/local/ct-${ct_version}/ct" /usr/local/bin/ct && \
    rm -f "chart-testing_${ct_version}_linux_amd64.tar.gz" && \
    mkdir /etc/ct && \
    cp /usr/local/ct-${ct_version}/etc/chart_schema.yaml /etc/ct/chart_schema.yaml && \
    cp /usr/local/ct-${ct_version}/etc/lintconf.yaml /etc/ct/lintconf.yaml

# wrap original entrypoint and change working dir for ct before calling exec
RUN mv /entrypoint.sh /entrypoint-kind.sh 
RUN sed -i -e '$s/exec "$@"/cd \/data \&\& exec "$@"/' entrypoint-kind.sh
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Ensure that the binary is available on path and is executable
RUN ct --help

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]