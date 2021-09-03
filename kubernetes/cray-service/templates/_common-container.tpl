{{/*
A common container spec for use in both containers and initContainers
Note that despite that it may look as though
*/}}
{{- define "cray-service.common-container" }}
- name: {{ .Container.name }}
  image: "{{ include "cray-service.image-prefix" .Root.Values }}{{ .Container.image.repository }}:{{ .Container.image.tag | default (include "cray-service.app-version" .Root ) }}"
  imagePullPolicy: {{ .Container.image.pullPolicy | default "IfNotPresent" }}
  {{- if or (.Root.Values.etcdCluster.enabled) (.Root.Values.sqlCluster.enabled) (.Root.Values.kafkaCluster.enabled) (.Container.env) }}
  env:
    {{- if .Root.Values.etcdCluster.enabled }}
    - name: ETCD_HOST
      value: "{{ include "cray-service.name" .Root }}-etcd-client"
    - name: ETCD_PORT
      value: "2379"
    {{- end }}
    {{- if .Root.Values.sqlCluster.enabled }}
    - name: POSTGRES_HOST
      value: "{{ include "cray-service.name" .Root }}-postgres"
    - name: POSTGRES_PORT
      value: "5432"
    {{- end }}
    {{- if .Root.Values.kafkaCluster.enabled }}
    - name: KAFKA_HOST
      value: "{{ include "cray-service.name" .Root }}-kafka-bootstrap"
    - name: KAFKA_PORT_PLAIN
      value: "9092"
    - name: KAFKA_PORT_TLS
      value: "9093"
    {{- end }}
    {{- if .Container.env -}}
    {{- toYaml .Container.env | nindent 4 -}}
    {{- end -}}
  {{- end -}}
  {{- if .Container.envFrom }}
  envFrom:
    {{- toYaml .Container.envFrom | nindent 4 -}}
  {{- end -}}
  {{- if .Container.command }}
  command:
    {{- toYaml .Container.command | nindent 4 -}}
  {{- end -}}
  {{- if .Container.args }}
  args:
    {{- toYaml .Container.args | nindent 4 -}}
  {{- end -}}
  {{- if .Container.ports }}
  ports:
    {{- toYaml .Container.ports | nindent 4 -}}
  {{- end -}}
  {{- if .Container.livenessProbe }}
  livenessProbe:
    {{- toYaml .Container.livenessProbe | nindent 4 -}}
  {{- end -}}
  {{- if .Container.readinessProbe }}
  readinessProbe:
    {{- toYaml .Container.readinessProbe | nindent 4 -}}
  {{- end -}}
  {{- if or (or .Container.volumeMounts (or .Root.Values.sqlCluster.enabled .Root.Values.kafkaCluster.enabled)) .Root.Values.mountSealedSecrets }}
  volumeMounts:
    {{- if .Root.Values.mountSealedSecrets -}}
    {{- range $val := .Root.Values.sealedSecrets }}
    - name: {{ $val.metadata.name | replace "_" "-" }}
      readOnly: true
      mountPath: "/secrets/sealed/{{ $val.metadata.name | replace "_" "-" }}"
    {{- end -}}
    {{- end -}}
    {{- if .Root.Values.sqlCluster.enabled }}
    {{- range .Root.Values.sqlCluster.users | keys }}
    - name: {{ . | replace "_" "-" }}-postgres-secrets
      readOnly: true
      mountPath: "/secrets/postgres/{{ . }}"
    {{- end }}
    {{- end }}
    {{- if .Root.Values.kafkaCluster.enabled }}
    - name: {{ include "cray-service.name" .Root }}-cluster-ca-cert
      readOnly: true
      mountPath: "/secrets/kafka/cluster"
    {{- end }}
    {{- if or .Container.volumeMounts }}
    {{- toYaml .Container.volumeMounts | nindent 4 -}}
    {{- end -}}
  {{- end -}}
  {{- if .Container.resources }}
  resources:
    {{- toYaml .Container.resources | nindent 4 -}}
  {{- end -}}
  {{- if .Container.lifecycle }}
  lifecycle:
    {{- toYaml .Container.lifecycle | nindent 4 -}}
  {{- end -}}
  {{- if .Container.securityContext }}
  securityContext:
    {{- toYaml .Container.securityContext | nindent 4 -}}
  {{- end -}}
  {{- if .Container.stdin }}
  stdin: {{ .Container.stdin }}
  {{- end -}}
  {{- if .Container.stdinOnce }}
  stdinOnce: {{ .Container.stdinOnce }}
  {{- end -}}
  {{- if .Container.terminationMessagePath }}
  terminationMessagePath: {{ .Container.terminationMessagePath | quote }}
  {{- end -}}
  {{- if .Container.tty }}
  tty: {{ .Container.tty }}
  {{- end -}}
  {{- if .Container.volumeDevices }}
  volumeDevices:
    {{- toYaml .Container.volumeDevices | nindent 4 -}}
  {{- end -}}
  {{- if .Container.workingDir }}
  workingDir: {{ .Container.workingDir | quote }}
  {{- end -}}
{{- end -}}
