apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "fullname" . }}
  labels:
    app: {{ template "fullname" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ template "fullname" . }}
  template:
    metadata:
      labels:
        app: {{ template "fullname" . }}
    spec:
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule
{{ if .Values.image.useImagePullSecrets }}
      imagePullSecrets:
        - name: {{ .Chart.Name }}-acr-secret
{{ end }}
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        resources:
{{ toYaml .Values.resources | indent 12 }}
        env:
          - name: ASPNETCORE_ENVIRONMENT
            value: Development
