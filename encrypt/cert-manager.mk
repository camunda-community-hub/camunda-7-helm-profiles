# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/
prodserver ?= https:\\/\\/acme-v02.api.letsencrypt.org/directory

.PHONY: cert-manager
cert-manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm install cert-manager jetstack/cert-manager \
	--namespace cert-manager \
  	--create-namespace \
  	--version v1.9.1 \
	--set installCRDs=true

.PHONY: letsencrypt-staging
letsencrypt-staging:
	cat ./encrypt/letsencrypt.yaml | sed -E "s/someone@somewhere.io/$(certEmail)/g" | kubectl create -n cert-manager -f -

.PHONY: letsencrypt-prod
letsencrypt-prod:
	cat ./encrypt/letsencrypt.yaml | sed -E "s/someone@somewhere.io/$(certEmail)/g" | sed -E "s/acme-staging-v02/acme-v02/g" | kubectl apply -n cert-manager -f -

#TODO: succeeds, but does not seem to have right effect
.PHONY: letsencrypt-prod-patch
letsencrypt-prod-patch:
	kubectl patch ClusterIssuer letsencrypt --type json -p '[{"op": "replace", "path": "/spec/acme/sever", "value":"$(prodserver)"}]'
	kubectl describe ClusterIssuer letsencrypt | grep letsencrypt.org

.PHONY: annotate-ingress-tls
annotate-ingress-tls:
	kubectl -n $(namespace) annotate ingress camunda-bpm-platform cert-manager.io/cluster-issuer=letsencrypt
	kubectl -n $(namespace) annotate ingress camunda-optimize cert-manager.io/cluster-issuer=letsencrypt

# clean cert-manager and cluster issuer
.PHONY: clean-cert-manager
clean-cert-manager:
	helm --namespace cert-manager delete cert-manager
	kubectl delete namespace cert-manager
