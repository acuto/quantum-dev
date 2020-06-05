{{ define "quantum-dev.service" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
  labels:
    app: {{ .Values.service.name }}
  namespace: {{ .Values.global.namespace  }}
spec:
  type: {{ .Values.service.type }}
  ports:
  {{- if eq .Values.service.type "NodePort" }}
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      nodePort: {{ .Values.service.nodePort }}
  {{- else }}
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  {{- end }}
  selector:
    app: {{ .Values.app.name }}
{{ end }}

{{ define "quantum-dev.statefulset" }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Values.app.name }}
  labels:
    app: {{ .Values.app.name }}
  namespace: {{ .Values.global.namespace  }}
spec:
  serviceName: {{ .Values.service.name }}
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Values.app.name }}
  template:
    metadata:
      labels:
        app: {{ .Values.app.name }}
    spec:
      terminationGracePeriodSeconds: {{ .Values.global.terminationGracePeriodSeconds  }}
      containers:
      - name: {{ .Values.app.name }}
        image: {{ .Values.app.imageName }}
        imagePullPolicy: {{ .Values.app.imagePullPolicy }}
        ports:
        - containerPort: {{ .Values.service.port }}
          name: jupyter
        command: 
        - bash
        - -c
        - {{ .Values.app.containerCommand | quote }}
        volumeMounts:
          - name: {{ .Values.app.name }}-notebooks
            mountPath: {{ .Values.app.containerMountPath }}
  volumeClaimTemplates:
    - metadata:
        name: {{ .Values.app.name }}-notebooks
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: {{ .Values.app.persistentStorage }}
{{ end }}  