# install apache directory studio the cluster

.PHONY: kube-apply-apacheds
kube-apply-apacheds:
	-kubectl create namespace apacheds
	kubectl create configmap camunda-ldif --from-file=./apacheds/seed.ldif -n apacheds
	kubectl create -f apacheds/apacheds-deployment.yaml -n apacheds
	kubectl create -f apacheds/apacheds-service.yaml -n apacheds
