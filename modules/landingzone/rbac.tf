# Entra AD Groups (Identity Foundation- Zero Trust)
resource "azuread_group" "platform_admins" {
  display_name     = "Platform Admins"
  security_enabled = true
}
resource "azuread_group" "platform_operators" {
  display_name     = "Platform Operators"
  security_enabled = true
}
resource "azuread_group" "platform_developers" {
  display_name     = "Platform Developers"
  security_enabled = true
}
resource "azuread_group" "platform_readers" {
  display_name     = "Platform Readers"
  security_enabled = true
}


// RBAC Role Assignments for Groups (Least Privilege + Prod Locked Down)
# resource "azurerm_role_assignment" "platform_admins" {
#   scope                = azurerm_management_group.platform.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_group.platform_admins.object_id
# }
# resource "azurerm_role_assignment" "operators_dev" {
#   scope                = azurerm_management_group.dev.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_group.platform_operators.object_id
# }
# resource "azurerm_role_assignment" "operators_staging" {
#   scope                = azurerm_management_group.staging.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_group.platform_operators.object_id
# }
# resource "azurerm_role_assignment" "developers_readonly" {
#   scope                = azurerm_management_group.prod.id
#   role_definition_name = "Reader"
#   principal_id         = azuread_group.platform_developers.object_id
# }
# resource "azurerm_role_assignment" "policy_contributors" {
#   scope                = azurerm_management_group.platform.id
#   role_definition_name = "Resource Policy Contributor"
#   principal_id         = azuread_group.platform_admins.object_id
# }

#########################################
# Azure Built-in Roles (Centralized) For Policy Enforcement
#########################################
data "azurerm_role_definition" "policy_contributor" {
  name = "Resource Policy Contributor"
}
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

# Role Assignments (Least Privilege)
resource "azurerm_role_assignment" "platform_admins" {
  scope              = azurerm_management_group.platform.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_group.platform_admins.object_id

}
resource "azurerm_role_assignment" "platform_operators" {
  scope              = azurerm_management_group.dev.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_group.platform_operators.object_id
}

resource "azurerm_role_assignment" "platform_developers" {
  scope              = azurerm_management_group.staging.id
  role_definition_id = data.azurerm_role_definition.contributor.id
  principal_id       = azuread_group.platform_developers.object_id
}
resource "azurerm_role_assignment" "platform_readers" {
  scope              = azurerm_management_group.prod.id
  role_definition_id = data.azurerm_role_definition.reader.id
  principal_id       = azuread_group.platform_readers.object_id
}

resource "azurerm_role_assignment" "policy_contributors" {
  scope              = azurerm_management_group.platform.id
  role_definition_id = data.azurerm_role_definition.policy_contributor.id
  principal_id       = azuread_group.platform_admins.object_id
}





// MFA enforcement via Conditional Access


# resource "azuread_conditional_access_policy" "mfa_policy" {
#   display_name = "Platform Admins - Require MFA"
#   state        = "enabledForReportingButNotEnforced"

#   conditions {
#     client_app_types = ["all"]

#     applications {
#       included_applications = ["All"]
#     }

#     users {
#       included_groups = [azuread_group.platform_admins.id]
#     }
#   }

#   grant_controls {
#     operator          = "OR"
#     built_in_controls = ["mfa"]
#   }

#   timeouts {
#     create = "10m"
#     update = "20m"
#   }
# }
