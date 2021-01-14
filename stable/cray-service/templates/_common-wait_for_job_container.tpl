{{/*
An InitContainer spec that waits for job completion
*/}}
{{- define "cray-service.common-wait-for-job-container" }}
- name: "{{.JobName }}"
  image: "{{ include "cray-service.image-prefix" .Root.Values }}loftsman/docker-kubectl:latest"
  command: 
    - /bin/sh
    - -c
    - |
      while true; do
        JOB_CONDITION="$(kubectl get jobs -n services -l app.kubernetes.io/name={{ .JobName }} -o jsonpath='{.items[0].status.conditions[0].type}')"
        JOB_CONDITION_RC=$?
        if [ $JOB_CONDITION_RC -eq 0 ]; then
          if [ "$JOB_CONDITION" == 'Complete' ]; then
            echo "Completed"
            break
          fi
          echo "Waiting for the {{ .JobName }} job in the services namespace to complete, current condition is $(kubectl get jobs -n services -l app.kubernetes.io/name={{ .JobName }} -o jsonpath='{.items[0].status}')"
          sleep 3
        elif [ $JOB_CONDITION_RC -ne 1 ]; then
          echo "'kubectl get jobs' failed with exit code $JOB_CONDITION_RC , failing"
          exit 1
        else
          echo "'kubectl get jobs' failed with exit code $JOB_CONDITION_RC , will retry"
          sleep 3
        fi
      done
  resources:
    requests:
      cpu: 30m
      memory: "20Mi"
    limits:
      cpu: 500m
      memory: "100Mi"

{{- end -}}
