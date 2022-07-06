{{/*
Expand the name of the chart.
*/}}
{{- define "seeker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "seeker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Env vars for database
*/}}
{{- define "seeker.db.env.vars" -}}
- name: SEEKER_SERVER_DB_SEEKER_MANAGED
  value: "false"
- name: SEEKER_SERVER_DB_HOST
  value: {{ .Values.externalDatabaseHost | default "seeker-postgres-service" | quote }}
- name: SEEKER_SERVER_DB_PORT
  value: {{ .Values.externalDatabasePort | default "5432" | quote }}
- name: SEEKER_SERVER_DB_USER
  value: {{ .Values.externalDatabaseUser | default "seeker" | quote }}
- name: POSTGRES_USER
  value: {{ .Values.externalDatabaseUser | default "seeker" | quote }}
- name: SEEKER_SERVER_DB_NAME
  value: {{ .Values.externalDatabaseName | default "inline" | quote }}
- name: POSTGRES_DB
  value: {{ .Values.externalDatabaseName | default "inline" | quote }}
- name: SEEKER_SERVER_DB_AUTH_MODE
  value: "1"
{{- end -}}

{{/*
Common labels
*/}}
{{- define "seeker.labels" -}}
app.kubernetes.io/name: {{ include "seeker.name" . }}
helm.sh/chart: {{ include "seeker.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}