{{/*
A common pod spec across the different kubernetes types: deployment, daemonset, statefulset.
*/}}
{{- define "cray-service.common-spec" -}}
{{- $root := . -}}
{{- if .Values.hostname }}
hostname: "{{ .Values.hostname }}"
{{- end }}
{{- if .Values.serviceAccountName }}
serviceAccountName: "{{ .Values.serviceAccountName }}"
{{- else if or (.Values.sqlCluster.enabled) (.Values.etcdCluster.enabled) }}
serviceAccountName: "jobs-watcher"
{{- end }}
{{- $initContainersLength := len .Values.initContainers -}}
{{- if or (gt $initContainersLength 0) (or .Values.sqlCluster.enabled (or .Values.etcdCluster.enabled .Values.kafkaCluster.enabled)) }}
initContainers:
{{- if .Values.kafkaCluster.enabled }}
- name: "wait-for-kafka"
  image: "{{ include "cray-service.image-prefix" $root.Values }}library/busybox:1.28.0-glibc"
  command: {{/* TODO: implement a more sophisticated wait, if necessary */}}
    - /bin/sh
    - -c
    - until nslookup {{ include "cray-service.fullname" $root }}-kafka-bootstrap; do echo waiting for kafka cluster; sleep 2; done;  echo 'Kafka Ready';
{{- end }}
{{- if .Values.sqlCluster.enabled }}
  {{- $input := dict "JobName" (nospace (cat (include "cray-service.fullname" $root) "-wait-for-postgres")) "Root" $root }}
  {{- include "cray-service.common-wait-for-job-container" $input }}
{{- end }}
{{- if .Values.etcdCluster.enabled }}
  {{- $input := dict "JobName" (nospace (cat (include "cray-service.fullname" $root) "-wait-for-etcd")) "Root" $root }}
  {{- include "cray-service.common-wait-for-job-container" $input }}
{{- end }}
{{- if .Values.trsWorker.enabled }}
  {{- $input := dict "JobName" (nospace (cat (include "cray-service.fullname" $root) "-wait-for-kafka-topics")) "Root" $root }}
  {{- include "cray-service.common-wait-for-job-container" $input }}
{{- end }}
{{- range $index, $initContainer := .Values.initContainers }}
  {{- $commonContainer := dict "Root" $root "Container" $initContainer }}
  {{- include "cray-service.common-container" $commonContainer }}
{{- end -}}
{{- end }}
containers:
{{- range $index, $container := .Values.containers }}
  {{- $commonContainer := dict "Root" $root "Container" $container }}
  {{- include "cray-service.common-container" $commonContainer }}
{{- end }}

{{/* security context */}}
{{- if .Values.securityContext }}
securityContext:
  {{ toYaml .Values.securityContext | nindent 2 }}
{{- end }}

{{/* volumes */}}
{{- $volumesLength := len .Values.volumes -}}
{{- if or (gt $volumesLength 0) (or .Values.sqlCluster.enabled .Values.kafkaCluster.enabled .Values.mountSealedSecrets) }}
volumes:
  {{- if .Values.mountSealedSecrets }}
  {{- range $val := .Values.sealedSecrets }}
  - name: {{ $val.metadata.name | replace "_" "-" }}
    secret:
      secretName: {{ $val.metadata.name | replace "_" "-" }}
  {{- end -}}
  {{- end -}}
  {{- if .Values.sqlCluster.enabled }}
  {{- range .Values.sqlCluster.users | keys }}
  - name: {{ . | replace "_" "-" }}-postgres-secrets
    secret:
      secretName: {{ . | replace "_" "-" }}.{{ include "cray-service.fullname" $root }}-postgres.credentials
  {{- end }}
  {{- end }}
  {{- if .Values.kafkaCluster.enabled }}
  - name: {{ include "cray-service.name" . }}-cluster-ca-cert
    secret:
      secretName: {{ include "cray-service.name" . }}-cluster-ca-cert
  {{- end }}
  {{- $volumesList := list }}
  {{- range $volume := .Values.volumes -}}
  {{- $volumesList = append $volumesList $volume -}}
  {{- end }}
{{- if $volumesList }}
{{ toYaml $volumesList | indent 2 }}
{{- end -}}
{{- end -}}
{{/* end volumes */}}

{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}
