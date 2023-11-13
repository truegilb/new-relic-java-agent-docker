# Dockerized Springboot Petclinic Service With New Relic Java Agent

Dockerized version of the [SpringBoot PetClinic service](https://github.com/spring-projects/spring-petclinic) with the [New Relic Java Agent](https://docs.newrelic.com/docs/apm/agents/java-agent/getting-started/introduction-new-relic-java/).

## Configure the Java agent

Before running the container you must modify the following environment variables in the Dockerfile to configure where the Java agent reports.

These two define a unique entity that is associated with a specific APM account and New Relic environment:
* Set the APM entity name: `ENV NEW_RELIC_APP_NAME=JavaPetClinic`
* License key for account: `ENV NEW_RELIC_LICENSE_KEY='<license_key>'`

Set the following based on which New Relic environment the APM account is associated with:
* US Production
    ```
    ENV NEW_RELIC_HOST=collector.newrelic.com
    ENV NEW_RELIC_API_HOST=rpm.newrelic.com
    ENV NEW_RELIC_METRIC_INGEST_URI=https://metric-api.newrelic.com/metric/v1
    ENV NEW_RELIC_EVENT_INGEST_URI=https://insights-collector.newrelic.com/v1/accounts/events
    ```
* EU Production
    ```
    ENV NEW_RELIC_HOST=collector.eu01.nr-data.net
    ENV NEW_RELIC_API_HOST=api.eu.newrelic.com
    ENV NEW_RELIC_METRIC_INGEST_URI=https://metric-api.eu.newrelic.com/metric/v1
    ENV NEW_RELIC_EVENT_INGEST_URI=https://insights-collector.eu01.nr-data.net/v1/accounts/events
    ```
* US Staging
    ```
    ENV NEW_RELIC_HOST=staging-collector.newrelic.com
    ENV NEW_RELIC_API_HOST=staging.newrelic.com
    ENV NEW_RELIC_METRIC_INGEST_URI=https://staging-metric-api.newrelic.com/metric/v1
    ENV NEW_RELIC_EVENT_INGEST_URI=https://staging-insights-collector.newrelic.com/v1/accounts/events
    ```

(OPTIONAL) Enable JFR monitoring for enhanced JVM details:
* `ENV NEW_RELIC_JFR_ENABLED=true`

## Building/Running Dockerized Petclinic Service

### Option 1: Docker Compose

Build and run:
`docker-compose up -d`

Stop:
`docker-compose down`

### Option 2: Docker Build/Run

Build Docker Image:
`docker build --tag petclinic-app .`

Run Docker Container:
`docker run -p 8080:8080 petclinic-app`

Stop Docker Container:
`docker ps`
`docker stop <CONTAINER ID>`

## Make a Request to the Petclinic Service

By default, the Petclinic Service will be accessible at: http://localhost:8080

Example `curl` request:
`curl --request GET --url http://localhost:8080/vets --header 'content-type: application/json'`

## Docker Hub

Steps to publish image to Docker Hub after it has been built.

1. Docker Login: `docker login`
2. Docker Tag: `docker tag petclinic-app jkellernr/new-relic-java-agent-spring-petclinic:petclinic-app` 
3. Docker Push: `docker push jkellernr/new-relic-java-agent-spring-petclinic:petclinic-app`
4. Docker Pull: `docker pull jkellernr/new-relic-java-agent-spring-petclinic:petclinic-app`

## Helm Charts For Publishing To Kubernetes

A helm chart has already been created (i.e. `helm create <chart_name>`) and configured for this project. All helm chart files can be found in the `helm-petclinic-app` directory.

### Configure Helm Chart To Use The Docker File For Petclinic Service

A publicly available Docker file of the SpringBoot Petclinic service with the New Relic Java agent has been published to Dockerhub repository at: `jkellernr/new-relic-java-agent-spring-petclinic:petclinic-app`

If you wish to use a different Docker image you can simply change the repository in the `helm-petclinic-app/values.yaml` as shown below:  
```yaml
image:
  repository: jkellernr/new-relic-java-agent-spring-petclinic:petclinic-app
```

### Install Helm Chart

By default, the Docker image is configured such that the Java agent will report data to a US Production New Relic APM environment, at a minimum you must set the `new_relic_license_key` for your US Production APM account when installing the helm chart.

#### Helm Chart Install Dry Run Debugging 

It is advisable to do a dry run (i.e. `helm install <chart_release_name> --dry-run --debug <chart_name>`) to debug before installing the chart:  
```shell
helm install helm-petclinic-app-release --dry-run \
--set new_relic_license_key="<license_key>" \
--debug helm-petclinic-app
```

#### Helm Chart Install

Install (i.e. `helm install <chart_release_name> <chart_name>`) the helm chart:  
```shell
helm install helm-petclinic-app-release \
--set new_relic_license_key="<license_key>" \
helm-petclinic-app
```

#### Optional Helm Chart Config For New Relic Java Agent

Below is an example showing all the New Relic Java agent config options that can be set when installing this helm chart. This example shows how to configure the Java agent to report to a US Staging APM account:  
```shell
helm install helm-petclinic-app-release \
--set new_relic_app_name="JavaPetClinicHelmChart" \
--set new_relic_license_key="<license_key>" \
--set new_relic_host="staging-collector.newrelic.com" \
--set new_relic_api_host="staging.newrelic.com" \
--set new_relic_metric_ingest_uri=https://staging-metric-api.newrelic.com/metric/v1 \
--set new_relic_event_ingest_uri=https://staging-insights-collector.newrelic.com/v1/accounts/events \
--set new_relic_jfr_enabled="\"true\"" \
helm-petclinic-app
```

#### Making Changes To The Helm Chart Install

You can uninstall (i.e. `helm uninstall <chart_release_name>`) the helm chart with the following command and then install it again with the updated settings:  
```shell
helm uninstall helm-petclinic-app-release
```

#### Verifying Helm Chart Deployment

Check deployment: `helm list -a` and `kubectl get deployments`  
Check where deployment is running: `kubectl get service`

#### Debugging

View PetClinic service logs in Kubernetes:  
`kubectl get pods`  
`kubectl logs <pod_name>`  

Get shell into docker container in kubernetes to view Java agent logs:  
`kubectl exec -it <pod_name> sh`  
`cd logs && cat newrelic_agent.log`  

#### Helm Chart Support For New Relic Java Agent

For documentation purposes here are the files that have been updated to support configuring the Java agent via Helm charts. These could be extended to support other Java agent config if desired.

values.yaml
```yaml
# New Relic Java agent config
new_relic_app_name: JavaPetClinicHelmChart
new_relic_license_key: license_key
new_relic_host: collector.newrelic.com
new_relic_api_host: rpm.newrelic.com
new_relic_metric_ingest_uri: https://metric-api.newrelic.com/metric/v1
new_relic_event_ingest_uri: https://insights-collector.newrelic.com/v1/accounts/events
new_relic_jfr_enabled: "true"
```

templates/secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-auth
data:
  new_relic_app_name: {{ .Values.new_relic_app_name | b64enc }}
  new_relic_license_key: {{ .Values.new_relic_license_key | b64enc }}
  new_relic_host: {{ .Values.new_relic_host | b64enc }}
  new_relic_api_host: {{ .Values.new_relic_api_host | b64enc }}
  new_relic_metric_ingest_uri: {{ .Values.new_relic_metric_ingest_uri | b64enc }}
  new_relic_event_ingest_uri: {{ .Values.new_relic_event_ingest_uri | b64enc }}
  new_relic_jfr_enabled: {{ .Values.new_relic_jfr_enabled | b64enc }}
```

templates/deployment.yaml
```yaml
          env:
            - name: "NEW_RELIC_APP_NAME"
              valueFrom:
                secretKeyRef:
                  key: new_relic_app_name
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_LICENSE_KEY"
              valueFrom:
                secretKeyRef:
                  key: new_relic_license_key
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_HOST"
              valueFrom:
                secretKeyRef:
                  key: new_relic_host
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_API_HOST"
              valueFrom:
                secretKeyRef:
                  key: new_relic_api_host
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_METRIC_INGEST_URI"
              valueFrom:
                secretKeyRef:
                  key: new_relic_metric_ingest_uri
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_EVENT_INGEST_URI"
              valueFrom:
                secretKeyRef:
                  key: new_relic_event_ingest_uri
                  name: {{ .Release.Name }}-auth
            - name: "NEW_RELIC_JFR_ENABLED"
              valueFrom:
                secretKeyRef:
                 key: new_relic_jfr_enabled
                  name: {{ .Release.Name }}-auth
```
