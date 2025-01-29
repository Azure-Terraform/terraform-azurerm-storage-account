apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: airflow-managed-identity-binding
  namespace: azurerm_storage_account.sa.name
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: airflow-managed-identity-svc-account
subjects:
  - kind: User
    name: var.airflow_source_mode.identity_id
    apiGroup: rbac.authorization.k8s.io