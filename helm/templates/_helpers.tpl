{{/*
Generate a name that includes the release name and chart name.
*/}}
{{- define "devpi.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}