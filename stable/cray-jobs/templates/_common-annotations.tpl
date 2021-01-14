{{/*
A common set of annotations to apply to resources.
*/}}
{{- define "cray-jobs.common-annotations" -}}
cray.io/jobs: "{{ include "cray-jobs.name" .Root }}"
{{ with .Root.Values.annotations -}}
{{ toYaml . }}
{{ end -}}
{{- with .JobMetadataAnnotations -}}
{{ toYaml . }}
{{ end -}}
{{- if .JobMetadataAnnotations -}}
{{- if and (index .JobMetadataAnnotations "helm.sh/hook") (not (index .JobMetadataAnnotations "helm.sh/hook-delete-policy")) }}
helm.sh/hook-delete-policy: before-hook-creation
{{- end -}}
{{- end -}}
{{- end -}}
