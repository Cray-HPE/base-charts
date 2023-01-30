{{/*
A common set of labels to apply to resources.
*/}}
{{- define "cray-postgresql.common-labels" -}}
helm.sh/base-chart: {{ include "cray-postgresql.base-chart" . }}
helm.sh/chart: {{ include "cray-postgresql.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ with .Values.labels -}}
{{ toYaml . -}}
{{- end -}}
{{ if .Values.partitionId -}}
cray.io/partition: {{ .Values.partitionId }}
{{- end -}}
{{- end -}}
