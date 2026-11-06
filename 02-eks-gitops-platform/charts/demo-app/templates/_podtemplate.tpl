{{/* Shared pod template — used by both the Rollout and the fallback Deployment. */}}
{{- define "demo-app.podTemplate" }}
      containers:
        - name: demo-app
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: 80
          resources:
{{ toYaml .Values.resources | indent 12 }}
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 3
          securityContext:
            allowPrivilegeEscalation: false
            runAsNonRoot: true
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
{{- end }}
