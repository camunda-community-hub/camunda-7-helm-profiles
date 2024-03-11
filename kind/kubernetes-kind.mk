.PHONY: kube
kube:
	kind create cluster --config=./kind/config.yaml
	kubectl apply -f ./kind/ssd-storageclass-kind.yaml

.PHONY: clean-kube-kind
clean-kube-kind: use-kube-kind
	kind delete cluster --name camunda-kind-cluster

.PHONY: use-kube-kind
use-kube-kind:
	kubectl config use-context kind-camunda-kind-cluster

.PHONY: urls
urls:
	@echo "A cluster management url is not available on Kind"
