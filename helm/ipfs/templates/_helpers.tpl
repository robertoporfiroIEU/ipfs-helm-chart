{{/*
Expand the name of the chart.
*/}}
{{- define "ipfs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ipfs.fullname" -}}
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
{{- define "ipfs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ipfs.labels" -}}
helm.sh/chart: {{ include "ipfs.chart" . }}
{{ include "ipfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ipfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ipfs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ipfs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ipfs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create secret data with automatic initialization
Parameter: [$, Secret name, [Secret key 1, Secret key 2, ...]]
*/}}
{{- define "ipfs.automaticHexSecret" -}}
{{- $ := index . 0 -}}
{{- $name := index . 1 -}}
{{- $key := index . 2 -}}
{{- $secretLength := int (index . 3) }}
{{- $userValue := index . 4 }}
{{- if $userValue }}
  {{ $key }}: {{ $userValue | b64enc | quote }}
{{- else if ($.Values.global).dev }}
  {{- $bs := printf "%s-%s" $name . | sha256sum -}}
  {{- $more_string := printf "%s%s%s%s%s%s%s%s%s%s" $bs $bs $bs $bs $bs $bs $bs $bs $bs $bs }}
  {{- $rand_list := $more_string | b32enc | lower | splitList "" -}}
  {{- $reduced_list := without $rand_list "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "=" }}
  {{ $key }}: {{ $reduced_list | join "" | trunc $secretLength | b64enc | quote }}
{{- else if and ($.Release.IsUpgrade) (lookup "v1" "Secret" $.Release.Namespace $name) }}
  {{ $key }}: {{ index (lookup "v1" "Secret" $.Release.Namespace $name).data $key }}
{{- else }}
  {{- $rand_list := randAlphaNum 1000 | splitList "" -}}
  {{- $reduced_list := without $rand_list "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" }}
  {{ $key }}: {{ $reduced_list | join "" | trunc $secretLength | b64enc | quote }}
{{- end }}
{{- end }}

{{/*
Create a swarm key
Parameter: [$, Secret name, [Secret key 1, Secret key 2, ...]]
*/}}
{{- define "ipfs.automaticSwarmKey" -}}
{{- $ := index . 0 -}}
{{- $name := index . 1 -}}
{{- $key := index . 2 -}}
{{- $userValue := index . 3 }}
{{- if $userValue }}
  {{ $key }}: {{ $userValue | b64enc | quote }}
{{- else if ($.Values.global).dev }}
  {{- $bs := printf "%s-%s" $name . | sha256sum -}}
  {{- $more_string := printf "%s%s%s%s%s%s%s%s%s%s" $bs $bs $bs $bs $bs $bs $bs $bs $bs $bs }}
  {{- $rand_list := $more_string | b32enc | lower | splitList "" -}}
  {{- $reduced_list := without $rand_list "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "=" }}
  {{ $key }}: {{ printf "/key/swarm/psk/1.0.0/\n/base16/\n%s" ($reduced_list | join "" | trunc 64) | b64enc | quote }}
{{- else if and ($.Release.IsUpgrade) (lookup "v1" "Secret" $.Release.Namespace $name) }}
  {{ $key }}: {{ index (lookup "v1" "Secret" $.Release.Namespace $name).data $key }}
{{- else }}
  {{- $rand_list := randAlphaNum 1000 | splitList "" -}}
  {{- $reduced_list := without $rand_list "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" }}
  {{ $key }}: {{ printf "/key/swarm/psk/1.0.0/\n/base16/\n%s" ($reduced_list | join "" | trunc 64) | b64enc | quote }}
{{- end }}
{{- end }}
