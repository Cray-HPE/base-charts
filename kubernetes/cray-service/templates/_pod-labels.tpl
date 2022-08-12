{{/*
Pod labels across the different types
*/}}
{{- define "cray-service.pod-labels" -}}
{{ if .Values.podLabels -}}
{{ with .Values.podLabels -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
{{- end -}}
