{{/*
Return the chart name
*/}}
{{- define "devpi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate a fullname (release + chart name)
*/}}
{{- define "devpi.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "devpi.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common selector labels
*/}}
{{- define "devpi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devpi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full set of labels for all resources.
Includes selector labels + identity labels.
*/}}
{{- define "devpi.labels" -}}
{{ include "devpi.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end }}