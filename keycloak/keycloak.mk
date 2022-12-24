#download the camunda keycloak jar and install in kube camunda

.PHONY: create-camunda-keycloak-config
create-camunda-keycloak-config:
	kubectl create configmap camunda-keycloak-config --from-file=./keycloak/production.yml -n $(namespace)
	kubectl create secret generic realm-secret --from-file=./keycloak/realm.json
