#pass env=full-stack
#pass env=dev
env ?= "full-stack"
chartValues ?= "./profiles/$(env)-camunda-values.yaml"
#chartValues ?= "./development/camunda-values.yaml"

# Camunda components will be installed into the following Kubernetes namespace
namespace ?= camunda
# Helm release name
release ?= camunda
# Helm chart coordinates for Camunda
chart ?= ../camunda-7-community-helm/charts/camunda-bpm-platform

# encryption params
# CFSSL Service to apply cert
service ?= zeebe-gateway
# CFSSL TLS secret name
secret_name ?= tls-secret
# CFSSL Cert Signing Reqest (CSR) signer name
signerName ?= example.com\/pdiddy
# letsencrypt
certEmail ?= YOUR_EMAIL@camunda.com

#cloud params
region ?= eastus
clusterName ?= MY_CLUSTER_NAME
resourceGroup ?= MY_CLUSTER_NAME-rg
# This dnsLabel value will be used like so: MY_DOMAIN_NAME.region.cloudapp.azure.com
dnsLabel ?= MY_DOMAIN_NAME
machineType ?= Standard_A8_v2
minSize ?= 1
maxSize ?= 6
fqdn ?= ${dnsLabel}.${region}.cloudapp.azure.com

# Database params
dbNamespace ?= camunda
dbRelease ?= workflow-database
dbSecretName ?= workflow-database-credentials
dbUserName ?= workflow
dbPassword ?= workflow

.PHONY: kind
kind: kube namespace \
postgres \
cert-manager letsencrypt-staging \
ingress-nginx-kind \
kube-apply-apacheds \
create-camunda-keycloak-config \
camunda \
annotate-ingress-tls \
metrics urls

.PHONY: kind-dev
kind-dev: kube namespace postgres ingress-nginx-kind camunda urls

.PHONY: local
local: namespace postgres ingress camunda urls

.PHONY: ingress
ingress: ingress

.PHONY: ingress-kind
ingress: ingress-kind

.PHONY: clean
clean: clean-camunda clean-postgres clean-ingress clean-kube

# include ./encrypt/cfssl/cfssl-certs.mk
include ./apacheds/apacheds.mk
include ./kind/kubernetes-kind.mk
include ./encrypt/cert-manager.mk
include ./keycloak/keycloak.mk
include ./metrics/metrics.mk
include ./nginx/ingress-nginx.mk
include ./postgres/postgres.mk
include ./camunda/camunda.mk
