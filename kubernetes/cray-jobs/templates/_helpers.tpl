{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cray-jobs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get an image prefix
*/}}
{{- define "cray-jobs.release-revision" -}}
{{- print .Release.Revision -}}
{{- end -}}

{{/*
Create a global for the Chart.yaml appVersion field.
Use a default of "latest" to keep some sort of backwards compatibility.
*/}}
{{- define "cray-jobs.app-version" -}}
{{- default "latest" .Values.global.appVersion | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cray-jobs.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create base chart name and version as used by the chart label.
*/}}
{{- define "cray-jobs.base-chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create actual chart name and version as used by the chart label.
*/}}
{{- define "cray-jobs.chart" -}}
{{- printf "%s-%s" (.Values.global.chart.name | default "unknown-chart-name") (.Values.global.chart.version | default "unknown-chart-version") | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get an image prefix
*/}}
{{- define "cray-jobs.image-prefix" -}}
{{- if .Values.imagesHost -}}
{{- printf "%s/" .Values.imagesHost -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}

{{/*
Renders/sets a list of containers in the appropriate container list of a job pod template
*/}}
{{- define "cray-jobs.render-containers" -}}
{{- $root := .Root }}
{{- $containers := list }}
{{- range $containerName, $containerSpec := .Containers -}}
{{- $newContainerSpec := merge (dict "name" $containerName) $containerSpec -}}
{{- $newImage := print (include "cray-jobs.image-prefix" $root) (index $containerSpec "image" "repository") ":" (index $containerSpec "image" "tag" | default (include "cray-jobs.app-version" $root)) -}}
{{- $_ := set $newContainerSpec "image" $newImage -}}
{{- $_ := set $newContainerSpec "imagePullPolicy" (index $containerSpec "image" "pullPolicy" | default "IfNotPresent") -}}
{{- $containers = append $containers $newContainerSpec -}}
{{- end -}}
{{- $_ := set .JobPodTemplateSpec .Key $containers -}}
{{- end -}}
