#download the camunda keycloak jar and install in kube camunda

.PHONY: create-camunda-keycloak-config
create-camunda-keycloak-config:
	kubectl create configmap camunda-keycloak-config --from-file=./keycloak/production.yml -n $(namespace)

# .PHONY: jar
# jar:
# 	curl https://repo1.maven.org/maven2/org/camunda/bpm/extension/camunda-platform-7-keycloak-run/7.17.0/camunda-platform-7-keycloak-run-7.17.0.jar --output ./keycloak/camunda-platform-7-keycloak-run-7.17.0.jar
#
# .PHONY: rm-jar
# rm-jar:
# 	-rm ./keycloak/camunda-platform-7-keycloak-run-*.jar

# .PHONY: create-camunda-keycloak-jar
# create-camunda-keycloak-jar:
# 	kubectl create configmap camunda-keycloak-jar --from-file=./keycloak/camunda-platform-7-keycloak-run-7.17.0.jar -n $(namespace)

# .PHONY: create-keycloak-pv
# create-keycloak-pv:
# 	-mkdir ~/tmpkubedata
# 	kubectl apply -f ./keycloak/keycloak-pv.yaml
#
# .PHONY: create-keycloak-pv-claim
# create-keycloak-pv-claim:
# 	kubectl apply -f ./keycloak/keycloak-pv-claim.yaml

	# kubectl exec --pod-running-timeout=5m camunda-bpm-platform-58b7f78b77-2gdml -- cp /usrlib/camunda-platform-7-keycloak-run-7.17.0.jar /camunda/configuration/userlib
	# kubectl exec --pod-running-timeout=5m camunda-bpm-platform-58b7f78b77-2gdml -- ./start.sh

# .PHONY: clean-keycloak
# 	kubectl delete pvc keycloak-pv-claim
