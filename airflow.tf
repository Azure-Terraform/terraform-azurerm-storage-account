resource "kubectl_manifest" "airflow_role" {
  count             = var.airflow_integration.enable ? 1 : 0
  server_side_apply = true
  yaml_body         = local.parsed_role_file
}

resource "kubectl_manifest" "airflow_role_binding" {
  count             = var.airflow_integration.enable ? 1 : 0
  server_side_apply = true
  yaml_body         = local.parsed_role_binding_file
}

resource "azurerm_role_assignment" "airflow_source_assignment" {
  count                = var.airflow_source_mode.enable ? 1 : 0
  scope                = azurerm_storage_account.sa.name
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.airflow_source_mode.identity_id
}