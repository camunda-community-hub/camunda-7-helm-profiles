# Camunda 7 Helm Profiles

## Architecture & Components

![C7 Architecture & Components](https://raw.githubusercontent.com/camunda-community-hub/camunda-7-helm-profiles/44e176e1be9ed8149270973c235aaa4f119ce9cb/static/c7-components.jpg)

### Integration
- The primary method of interacting with the Camunda 7 engine is with the REST Api.
- Integration with other systems is done using the External Task Client.
- Integration with user tasks is through the Task Api and using the C7 Client as a abstraction
- Authorization and Authentication is done through Keycloak securing the Camunda7 Webapps and the REST api.

### Components
- Camunda 7 Engine
- DMN Engine
- Spring-Boot (Camunda-Run)
- Camunda 7 Web Apps (Cockpit, Tasklist, Admin)
- External Task Client (Java SpringBoot)
- Prometheus
- Graphana
- Keycloak
- LDAP (Apacheds)
- Nginx
- Demo Apps (ReactJS, SpringBoot Data, Camunda C7 client)
- Kubernetes (container orchestration)
- Docker

### Goals
- [X] Camunda 7 BPMN, DMN engine, and Webapps, RestAPI, Swagger
- [X] Camunda Optimize
- [X] Metrics (Prometheus, Graphana)
- [X] Keycloak integration with Camunda to manage authentication and authorizations
- [ ] SSO
- [X] Secure traffic with TLS, Kube Certmanger and Letsencrypt
- [X] LDAP integration for user/group management
- [ ] Profile for AWS
- [ ] Profile for Azure
- [ ] Separate deployment of Webapps node and Headless REST api node  
- [ ] Graphana dashboard for Camunda 7
- [ ] Graphana Ingress
- [ ] Demo UI, Demo Data and C7 Client
- [ ] CockroachDB
- [ ] Vault auto password rotation
- [ ] GRPC external task client support

## Prerequisites to run
- Download or clone the forked version of camunda-7-community-helm. This is a temporary measure until the camunda-community-hub/camunda-7-community-helm is updated.

  https://github.com/paulhoot/camunda-7-community-helm

- Point the Makefile to the chart where you placed it on your filesystem

  chart ?= ../camunda-7-community-helm/charts/camunda-bpm-platform

## Profiles

- full-stack
- development

### run make full-stack kind

`make certEmail=<<YOUR_EMAIL>> chart=<<YOUR_PROJECTS>>/camunda-7-community-helm/charts/camunda-bpm-platform`

### run make development kind

`make kind-dev env=dev chart=...`

### run make development local

`make local env=dev chart=...`

## Access Apps on profile (kind full-stack)

### Camunda Apps
* Access camunda at http://camunda.127.0.0.1.nip.io user/pass demo/demo

* Access optimize at http://optimize.127.0.0.1.nip.io user/pass demo/demo

### Keycloak

* Access keycloak at http://keycloak.127.0.0.1.nip.io user/pass admin/admin   

**NOTE:** User are automatically added and configured using LDAP through the Keycloak user federation integration. User (demo/demo) has been added to the Keycloak Camunda Realm and in the camunda-admin group.

**NOTE:** if you change the Keycloak client secret in keycloak/production.yml you must update keycloak/realm.json

### ApacheDS LDAP

Users and Groups are stored in LDAP. Keycloak is configured to use LDAP provider and directly integrates to Camunda through the Keycloak Plugin.

**NOTE:** This allows us to create and configure Users and Groups in an automated fashion and eliminates the need to manually configure Users in Keycloak or Camunda.  

**IMPORTANT:** for Cockpit users it's still necessary to create Authorizations in Camunda Admin Panel

### Graphana

#### To access Graphana run port forward

`kubectl get pods --all-namespaces`

`kubectl port-forward metrics-grafana-<<your-pod-id>> 3000:3000 -n default`

* Access Graphana at http://localhost:3000/ user/pass camunda/camunda

`kubectl get secret grafana-admin-password -o jsonpath='{.data.admin-user}' | base64 --decode`

`kubectl get secret grafana-admin-password -o jsonpath='{.data.admin-password}' | base64 --decode`

More info
- https://camunda.com/blog/2022/10/monitoring-camunda-platform-7-with-prometheus/
