# Camunda 7 Helm Profiles

## Profiles

- full-stack
- development

### run make full-stack kind

`make`

### run make development kind

`make env=dev`

### run make development local

`make local env=dev`


## Access Apps on profile (kind full-stack)

### Graphana

#### To access Graphana run port forward

`kubectl port-forward metrics-grafana-6b4967c699-rxwbf 3000:3000 -n default`

* Access Graphana at http://localhost:3000/ user/pass camunda/camunda

`kubectl get secret grafana-admin-password -o jsonpath='{.data.admin-user}' | base64 --decode`

`kubectl get secret grafana-admin-password -o jsonpath='{.data.admin-password}' | base64 --decode`

More info
- https://camunda.com/blog/2022/10/monitoring-camunda-platform-7-with-prometheus/

### Camunda Apps
* Access camunda at http://camunda.127.0.0.1.nip.io user/pass demo/demo

* Access optimize at http://optimize.127.0.0.1.nip.io user/pass demo/demo

### Keycloak

* Access keycloak at http://keycloak.127.0.0.1.nip.io user/pass admin/admin   


## Architecture & Components

![C7 Architecture & Components]("https://raw.githubusercontent.com/camunda-community-hub/camunda-7-helm-profiles/44e176e1be9ed8149270973c235aaa4f119ce9cb/static/c7-components.jpg")


### Components
- Camunda 7 Engine
- DMN Engine
- Spring-Boot (Camunda-Run)
- Camunda 7 Web Apps (Cockpit, Tasklist, Admin)
- Prometheus
- Graphana
- Keycloak
- LDAP
- Nginx
- Demo Apps (ReactJS, SpringBoot Data, Camunda C7 client)
- Kubernetes (container orchestration)
- Docker


Goals
- [X] Camunda 7 BPMN, DMN engine, and Webapps, RestAPI, Swagger
- [X] Camunda Optimize
- [X] Metrics (Prometheus, Graphana)
- [ ] Keycloak integration with Camunda to manage auth authorizations
- [ ] Secure traffic with TLS, Kube Certmanger and Letsencrypt
- [ ] 2 App nodes, Webapps node and Headless REST api node  
- [ ] LDAP integration for user/group management
- [ ] Graphana dashboard for Camunda 7
- [ ] Demo UI, Demo Data and C7 Client
- [ ] CockroachDB
- [ ] Graphana Ingress
- [ ] Vault auto password rotation
- [ ] GRPC external task client support
- [ ] Profile for AWS
- [ ] Profile for Azure
