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

# .PHONY: kind
# kind: kube namespace \
# 	postgres \
# 	create-camunda-keycloak-config \
# 	camunda

.PHONY: kind
kind: kube namespace \
postgres \
cert-manager letsencrypt-staging \
ingress-nginx-kind \
create-camunda-keycloak-config \
camunda \
annotate-ingress-tls \
metrics urls

.PHONY: local
local: namespace postgres ingress camunda urls

.PHONY: ingress
ingress: ingress

.PHONY: ingress-kind
ingress: ingress-kind

.PHONY: clean
clean: clean-camunda clean-postgres clean-ingress clean-kube

.PHONY: download-camunda-keycloak-jar
download-camunda-keycloak-jar: jar

.PHONY: delete-camunda-keycloak-jar
delete-camunda-keycloak-jar: rm-jar

# .PHONY: url-grafana
# url-grafana:
# 	@echo "http://`kubectl get svc metrics-grafana-loadbalancer -n default -o 'custom-columns=ip:status.loadBalancer.ingress[0].ip' | tail -n 1`/d/I4lo7_EZk/zeebe?var-namespace=$(namespace)"

# .PHONY: open-grafana
# open-grafana:
# 	xdg-open http://$(shell kubectl get services metrics-grafana-loadbalancer -n default -o jsonpath={..ip})/d/I4lo7_EZk/zeebe?var-namespace=$(namespace) &

include ./kind/kubernetes-kind.mk
# include $(helmProfilesDir)/certs/tls-certs.mk
include ./encrypt/cert-manager.mk
include ./keycloak/keycloak.mk
include ./metrics/metrics.mk
include ./nginx/ingress-nginx.mk
include ./postgres/postgres.mk
include ./camunda/camunda.mk
