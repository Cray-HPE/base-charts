{{/*
Pod annotations across the different types
*/}}
{{- define "cray-service.pod-annotations" -}}
service.cray.io/public: "{{ .Values.service.enabled }}"
{{ if .Values.podAnnotations -}}
{{ with .Values.podAnnotations -}}
{{ toYaml . -}}
{{- end -}}
{{- else -}}
{{ if .Values.etcdCluster.enabled -}}
traffic.sidecar.istio.io/excludeOutboundPorts: 2379,2380
{{- end -}}
{{- end -}}
{{- end -}}
