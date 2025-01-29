apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: airflow-managed-identity-svc-account
  namespace: azurerm_storage_account.sa.name
rules:
  - apiGroups:
      - ""
    resources:
      - pods
      - pods/exec
      - pods/log
    verbs:
      - get
      - list
      - watch
      - create
      - patch
      - update
      - delete