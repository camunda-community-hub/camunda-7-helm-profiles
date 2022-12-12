.PHONY: ingress
ingress: install-ingress-nginx

.PHONY: install-ingress-nginx
ingress-nginx: create-ingress-nginx-namespace add-nginx-repo
	helm install nginx-stable nginx-stable/nginx-ingress --namespace ingress-nginx

.PHONY: install-ingress-nginx-tls
install-ingress-nginx-tls: create-ingress-nginx-namespace add-kube-nginx-repo
	helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --wait \
	--set controller.service.annotations."nginx\.ingress.kubernetes.io/ssl-redirect"="true" \
	--set controller.service.annotations."cert-manager.io/cluster-issuer"="letsencrypt"

.PHONY: install-ingress-nginx-azure
install-ingress-nginx-tls: create-ingress-nginx-namespace add-kube-nginx-repo
	helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --wait \
	--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=$(dnsLabel) \
	--set controller.service.annotations."nginx\.ingress.kubernetes.io/ssl-redirect"="true" \
	--set controller.service.annotations."cert-manager.io/cluster-issuer"="letsencrypt"

.PHONY: ingress-nginx-kind
ingress-nginx-kind:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

.PHONY: create-ingress-nginx-namespace
create-ingress-nginx-namespace:
	-kubectl create namespace ingress-nginx

.PHONY: add-kube-nginx-repo
add-kube-nginx-repo:
	-helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	-helm repo update ingress-nginx
	-helm search repo ingress-nginx

.PHONY: add-nginx-repo
add-nginx-repo:
	-helm repo add nginx-stable https://helm.nginx.com/stable
	-helm repo update nginx-stable
	-helm search repo nginx-stable

.PHONY: camunda-values-nginx.yaml
camunda-values-nginx.yaml: ingress-ip-from-service
	sed "s/127.0.0.1/$(IP)/g;" ../ingress-nginx/camunda-values.yaml > ./camunda-values-nginx.yaml

.PHONY: ingress-ip-from-service
ingress-ip-from-service:
	$(eval IP := $(shell kubectl get service -w ingress-nginx-controller -o 'go-template={{with .status.loadBalancer.ingress}}{{range .}}{{.ip}}{{"\n"}}{{end}}{{.err}}{{end}}' -n ingress-nginx 2>/dev/null | head -n1))
	echo "Ingress controller will be configured to use address: http://$(IP).nip.io"

.PHONY: clean-ingress
clean-ingress:
	-helm --namespace ingress-nginx uninstall ingress-nginx
	-kubectl delete -n ingress-nginx pvc -l app.kubernetes.io/instance=ingress-nginx
	-kubectl delete namespace ingress-nginx
