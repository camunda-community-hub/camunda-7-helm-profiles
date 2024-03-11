.PHONY: postgres
postgres: db-namespace create-secret install-postgres

.PHONY: db-namespace
db-namespace:
	-kubectl create namespace $(dbNamespace)
	# -kubectl config set-context --current --namespace=$(namespace)

.PHONY: install-postgres
install-postgres:
	-helm repo add bitnami https://charts.bitnami.com/bitnami
	-helm repo update bitnami
	helm --namespace $(dbNamespace) install $(dbRelease) \
		--set global.postgresql.auth.username=workflow,global.postgresql.auth.password=workflow,global.postgresql.auth.database=workflow\
		bitnami/postgresql

.PHONY: create-secret
create-secret:
	-kubectl create secret generic \
    $(dbSecretName) \
    --from-literal=DB_USERNAME=$(dbUserName) \
    --from-literal=DB_PASSWORD=$(dbPassword) \
		--namespace $(namespace)

.PHONY: clean-postgres
clean-postgres:
	-helm --namespace $(dbNamespace) uninstall $(dbRelease)
	-kubectl delete -n $(dbNamespace) pvc -l app.kubernetes.io/instance=$(dbRelease)
	-kubectl delete namespace $(dbNamespace)
	-kubectl delete secret $(dbSecretName) -n $(dbNamespace)
