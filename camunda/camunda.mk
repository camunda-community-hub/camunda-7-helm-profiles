.PHONY: camunda
camunda: namespace
	@echo "Attempting to install camunda7 using chartValues: $(chartValues)"
	# -helm dependency build
	-helm repo add camunda7 https://helm.cch.camunda.cloud
	-helm repo update camunda7
	helm search repo $(chart)
	helm install --namespace $(namespace) $(release) $(chart) -f $(chartValues) --skip-crds --debug

.PHONY: namespace
namespace:
	-kubectl create namespace $(namespace)
	-kubectl config set-context --current --namespace=$(namespace)

# Generates templates from the camunda helm charts, useful to make some more specific changes which are not doable by the values file.
.PHONY: template
template:
	helm template $(release) $(chart) -f $(chartValues) --skip-crds --output-dir .
	@echo "To apply the templates use: kubectl apply -f camunda-platform/templates/ -n $(namespace)"

.PHONY: keycloak-password
keycloak-password:
	$(eval kcPassword := $(shell kubectl get secret --namespace $(namespace) "$(release)-keycloak" -o jsonpath="{.data.admin-password}" | base64 --decode))
	@echo KeyCloak Admin password: $(kcPassword)

.PHONY: config-keycloak
config-keycloak: keycloak-password
	kubectl wait --for=condition=Ready pod -l app.kubernetes.io/component=keycloak --timeout=600s
	kubectl -n $(namespace) exec -it $(release)-keycloak-0 -- /opt/bitnami/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE --server http://localhost:8080/auth --realm master --user admin --password $(kcPassword)
	kubectl -n $(namespace) exec -it $(release)-keycloak-0 -- /opt/bitnami/keycloak/bin/kcadm.sh update realms/camunda-platform -s sslRequired=NONE --server http://localhost:8080/auth --realm master --user admin --password $(kcPassword)

.PHONY: clean-camunda
clean-camunda:
	-helm --namespace $(namespace) uninstall $(release)

.PHONY: clean-all 
clean-all: clean-camunda clean-postgres
	-kubectl delete -n $(namespace) pvc -l app.kubernetes.io/instance=$(release)
	-kubectl delete -n $(namespace) pvc -l app=elasticsearch-master
	-kubectl delete namespace $(namespace)

.PHONY: logs
logs:
	kubectl logs -f -n $(namespace) -l app.kubernetes.io/name=zeebe

.PHONY: watch
watch:
	kubectl get pods -w -n $(namespace)

.PHONY: pods
pods:
	kubectl get pods --namespace $(namespace)

.PHONY: url-grafana
url-grafana:
	@echo "http://`kubectl get svc metrics-grafana-loadbalancer -n default -o 'custom-columns=ip:status.loadBalancer.ingress[0].ip' | tail -n 1`/d/I4lo7_EZk/zeebe?var-namespace=$(namespace)"

.PHONY: open-grafana
open-grafana:
	xdg-open http://$(shell kubectl get services metrics-grafana-loadbalancer -n default -o jsonpath={..ip})/d/I4lo7_EZk/zeebe?var-namespace=$(namespace) &
