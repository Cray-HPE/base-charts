{{/*
A common set of labels to apply to resources.
*/}}
{{- define "cray-jobs.common-labels" -}}
helm.sh/base-chart: {{ include "cray-jobs.base-chart" . }}
helm.sh/chart: {{ include "cray-jobs.chart" .Values.chart }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ with .Values.labels -}}
{{ toYaml . -}}
{{- end -}}
{{- end -}}
