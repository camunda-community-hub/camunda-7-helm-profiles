#download the camunda keycloak jar and install in kube camunda

.PHONY: install-keycloak
install-keycloak:
	kubectl create namespace keycloak
	helm install keycloak -f ./keycloak/custom-values.yaml oci://registry-1.docker.io/bitnamicharts/keycloak -n keycloak

.PHONY: create-camunda-keycloak-config
create-camunda-keycloak-config:
	kubectl create configmap camunda-keycloak-config --from-file=./keycloak/production.yml -n $(namespace)
	kubectl create secret generic realm-secret --from-file=./keycloak/realm.json -n $(namespace)

.PHONY: delete-keycloak
delete-keycloak:
	helm delete keycloak -n keycloak
