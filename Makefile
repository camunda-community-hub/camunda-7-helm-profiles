# chartValues ?= "./profiles/full-stack-camunda-values.yaml"
# chartValues ?= "./profiles/dev-camunda-values.yaml"
chartValues ?= "./profiles/full-stack-sso-camunda-values.yaml"

# Camunda components will be installed into the following Kubernetes namespace
namespace ?= camunda
# Helm release name
release ?= camunda
# Helm chart coordinates for Camunda
# chart ?= camunda7/camunda-bpm-platform
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
project ?= camunda-researchanddevelopment
region ?= us-central1-a
clusterName ?= MY_CLUSTER_NAME
resourceGroup ?= MY_CLUSTER_NAME-rg
# This dnsLabel value will be used like so: MY_DOMAIN_NAME.region.cloudapp.azure.com
dnsLabel ?= MY_DOMAIN_NAME
machineType ?= n1-standard-16
minSize ?= 1
maxSize ?= 6
fqdn ?= ${dnsLabel}.${region}.cloudapp.azure.com
baseDomainName ?= nip.io

# Database params
crdbNamespace ?= cockroachdb
crdbRelease ?= workflow-crdb
dbNamespace ?= postgres
dbRelease ?= workflow-database
dbSecretName ?= workflow-database-credentials
dbUserName ?= workflow
dbPassword ?= workflow

ifeq ($(OS),Windows_NT)
    root ?= $(CURDIR)
else
    root ?= $(shell pwd)
endif

.PHONY: kind
kind: kube use-kube-kind namespace \
postgres \
cert-manager letsencrypt-staging \
ingress-nginx-kind \
kube-apply-apacheds \
create-camunda-keycloak-config \
camunda \
annotate-ingress-tls \
# metrics urls

.PHONY: kind-dev
kind-dev: kube use-kube-kind namespace postgres ingress-nginx-kind camunda urls

.PHONY: kind-dev-crdb
kind-dev-crdb: kube use-kube-kind namespace crdb ingress-nginx-kind camunda urls

.PHONY: local
local: namespace postgres ingress camunda urls

.PHONY: google
google: namespace \
	postgres install-ingress-nginx cert-manager letsencrypt-prod \
	camunda-values-nginx.yaml camunda annotate-ingress-tls

.PHONY: kube-gke
kube-gke: kube-gke metrics

.PHONY: ingress
ingress: ingress

.PHONY: ingress-kind
ingress: ingress-kind

.PHONY: clean
clean: clean-camunda clean-postgres clean-ingress clean-kube-kind

# include ./encrypt/cfssl/cfssl-certs.mk
include ./apacheds/apacheds.mk
include ./kind/kubernetes-kind.mk
include ./encrypt/cert-manager.mk
include ./keycloak/keycloak.mk
include ./metrics/metrics.mk
include ./nginx/ingress-nginx.mk
include ./postgres/postgres.mk
include ./postgres/cockroachdb.mk
include ./google/kubernetes-gke.mk
include ./camunda/camunda.mk
include ./utils/utils.mk
