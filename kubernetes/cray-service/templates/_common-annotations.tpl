{{/*
A common set of annotations to apply to resources.
*/}}
{{- define "cray-service.common-annotations" -}}
cray.io/service: {{ include "cray-service.name" . }}
{{ with .Values.annotations -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
