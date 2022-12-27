{{/*
Expand the name of the chart.
*/}}
{{- define "canal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "canal.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "canal.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "canal.labels" -}}
helm.sh/chart: {{ include "canal.chart" . }}
{{ include "canal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "canal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "canal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "canal.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "canal.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "canal-admin.name" -}}
{{- printf "%s-admin" (include "canal.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the full name of the canal-admin.
*/}}
{{- define "canal-admin.fullname" -}}
{{- printf "%s-admin" (include "canal.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "canal-server.name" -}}
{{- printf "%s-server" (include "canal.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the full name of the canal-server.
*/}}
{{- define "canal-server.fullname" -}}
{{- printf "%s-server" (include "canal.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "canal-zookeeper.fullname" -}}
{{- if .Values.zookeeper.enabled -}}
{{- printf "canal-zookeeper" -}}
{{- else -}}
{{- default "" .Values.zookeeper.extralUrl -}}
{{- end -}}
{{- end -}}