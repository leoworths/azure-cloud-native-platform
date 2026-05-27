########################################
# PHASE 1 - GOVERNANCE & ZERO TRUST
# Management Group Scoped Policies
########################################

########################################
# DENY PUBLIC IP (ZERO TRUST)
# ########################################
# resource "azurerm_policy_definition" "deny_public_ip" {
#   name                = "deny-public-ip"
#   display_name        = "Deny Public IPs Except Allowed Resource Group"
#   description         = "Only Allowed Resource Group can create Public IPs"
#   policy_type         = "Custom"
#   mode                = "All"
#   management_group_id = azurerm_management_group.platform.id

#   parameters = jsonencode({
#     allowedResourceGroup = {
#       type = "String"
#       metadata = {
#         description = "Allowed Resource Group for Public IPs"
#       }
#     }
#     effect = {
#       type          = "String"
#       allowedValues = ["Audit", "Deny"]
#       defaultValue  = "Deny"
#     }
#   })

#   policy_rule = jsonencode({
#     if = {
#       allOf = [
#         { field = "type", equals = "Microsoft.Network/publicIPAddresses" },
#         {
#           not = {
#             value  = "[resourceGroup().name]"
#             equals = "[parameters('allowedResourceGroup')]"
#           }
#         }
#       ]
#     }
#     then = { effect = "[parameters('effect')]" }
#   })

#   metadata = jsonencode({ category = "Network" })
# }


resource "azurerm_policy_definition" "deny_public_ip" {
  name                = "deny-public-ip"
  display_name        = "Restrict Public IPs to Hub Resource Group"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({
    allowedResourceGroups = {
      type = "Array"
    }
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny"]
      defaultValue  = "Deny"
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Network/publicIPAddresses"
        },
        {
          not = {
            value = "[resourceGroup().name]"
            in    = "[parameters('allowedResourceGroups')]"
          }
        }
      ]
    }
    then = {
      effect = "[parameters('effect')]"
    }
  })
}





########################################
# REQUIRE COST CENTER TAG
########################################
resource "azurerm_policy_definition" "require_cost_center" {
  name                = "require-cost-center"
  display_name        = "Require CostCenter Tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({
    defaultCostCenter = {
      type = "String"
      metadata = { description = "Default CostCenter tag value" }
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Resources/resourceGroups" },
        { not = { field = "tags['CostCenter']", exists = true } }
      ]
    }
    then = {
      effect = "Modify"
      details = {
        roleDefinitionIds = [
          "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ]
        conflictEffect = "Audit"
        operations = [
          {
            operation = "addOrReplace"
            field     = "tags['CostCenter']"
            value     = "[parameters('defaultCostCenter')]"
          }
        ]
      }
    }
  })

  metadata = jsonencode({ category = "Cost Management" })
}

########################################
# REQUIRE ENVIRONMENT TAG
########################################
resource "azurerm_policy_definition" "require_environment_tag" {
  name                = "require-environment-tag"
  display_name        = "Require Environment Tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({
    defaultEnv = {
      type = "String"
      metadata = { description = "Default environment tag" }
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Resources/resourceGroups" },
        { not = { field = "tags['Env']", exists = true } }
      ]
    }
    then = {
      effect = "Modify"
      details = {
        roleDefinitionIds = [
          "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ]
        conflictEffect = "Audit"
        operations = [
          {
            operation = "addOrReplace"
            field     = "tags['Env']"
            value     = "[parameters('defaultEnv')]"
          }
        ]
      }
    }
  })

  metadata = jsonencode({ category = "Governance" })
}

########################################
# REQUIRE OWNER TAG
########################################
resource "azurerm_policy_definition" "require_owner_tag" {
  name                = "require-owner-tag"
  display_name        = "Require Owner Tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({
    defaultOwner = {
      type = "String"
      metadata = { description = "Default owner tag" }
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Resources/resourceGroups" },
        { not = { field = "tags['Owner']", exists = true } }
      ]
    }
    then = {
      effect = "Modify"
      details = {
        roleDefinitionIds = [
          "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ]
        conflictEffect = "Audit"
        operations = [
          {
            operation = "addOrReplace"
            field     = "tags['Owner']"
            value     = "[parameters('defaultOwner')]"
          }
        ]
      }
    }
  })

  metadata = jsonencode({ category = "Governance" })
}

########################################
# ALLOWED LOCATIONS
########################################
resource "azurerm_policy_definition" "allowed_locations" {
  name                = "allowed-locations"
  display_name        = "Allowed Azure Locations"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({
    allowedLocations = {
      type = "Array"
      metadata = { description = "Allowed Azure regions" }
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "location", notEquals = "global" },
        { not = { field = "location", in = "[parameters('allowedLocations')]" } }
      ]
    }
    then = { effect = "Deny" }
  })

  metadata = jsonencode({ category = "Governance" })
}

########################################
# DENY PUBLIC STORAGE
########################################
resource "azurerm_policy_definition" "deny_public_storage" {
  name                = "deny-public-storage"
  display_name        = "Deny Public Storage Access"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.platform.id

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Storage/storageAccounts" },
        {
          field  = "Microsoft.Storage/storageAccounts/allowBlobPublicAccess"
          equals = "true"
        }
      ]
    }
    then = { effect = "Deny" }
  })

  metadata = jsonencode({ category = "Security" })
}

########################################
# ENFORCE HTTPS
########################################
resource "azurerm_policy_definition" "enforce_https" {
  name                = "enforce-https"
  display_name        = "Enforce HTTPS Only"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.platform.id

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Storage/storageAccounts" },
        {
          field  = "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly"
          equals = "false"
        }
      ]
    }
    then = { effect = "Deny" }
  })

  metadata = jsonencode({ category = "Security" })
}

########################################
# DENY NIC PUBLIC IP
########################################

# resource "azurerm_policy_definition" "deny_nic_public_ip" {
#   name                = "deny-nic-public-ip"
#   display_name        = "Deny Public IP on NICs"
#   policy_type         = "Custom"
#   mode                = "All"
#   management_group_id = azurerm_management_group.platform.id

#   policy_rule = jsonencode({
#     if = {
#       allOf = [
#         {
#           field  = "type"
#           equals = "Microsoft.Network/networkInterfaces"
#         },
#         {
#           field  = "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIPAddress.id"
#           exists = true
#         }
#       ]
#     }
#     then = {
#       effect = "Deny"
#     }
#   })

#   metadata = jsonencode({ category = "Network" })
# }

resource "azurerm_policy_definition" "deny_nic_public_ip" {

  name                = "deny-nic-public-ip"
  display_name        = "Deny Public IP on NICs"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.platform.id

  parameters = jsonencode({

    effect = {
      type = "String"

      allowedValues = [
        "Audit",
        "Deny",
        "Disabled"
      ]

      defaultValue = "Deny"
    }
  })

  policy_rule = jsonencode({

    if = {
      allOf = [

        {
          field  = "type"
          equals = "Microsoft.Network/networkInterfaces"
        },

        {
          field  = "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIPAddress.id"
          exists = true
        }
      ]
    }

    then = {
      effect = "[parameters('effect')]"
    }
  })

  metadata = jsonencode({
    category = "Network"
  })
}

########################################
# POLICY INITIATIVE
########################################
resource "azurerm_management_group_policy_set_definition" "platform_governance" {
  name                = "platform-governance"
  display_name        = "Platform Governance Initiative"
  policy_type         = "Custom"
  management_group_id = azurerm_management_group.platform.id

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_ip.id
    reference_id         = "denyPublicIp"
    parameter_values = jsonencode({
      allowedResourceGroups = {
        value = ["${var.prefix}-hub-rg"]
      }
      effect = {
        value = var.environment == "prod" ? "Deny" : "Audit"
      }
    })
  }

  # policy_definition_reference {
  #   policy_definition_id = azurerm_policy_definition.deny_public_ip.id
  #   reference_id         = "denyPublicIp"

  #   parameter_values = jsonencode({
  #     allowedResourceGroup = { value = ["${var.prefix}-hub-rg"] }
  #     effect               = { value = var.environment == "dev" ? "Audit" : "Deny" }
  #   })
  # }
  # policy_definition_reference {
  #   policy_definition_id = azurerm_policy_definition.deny_public_ip.id
  #   reference_id         = "denyPublicIp"

  #   parameter_values = jsonencode({
  #     effect = {
  #     value = var.environment == "prod" ? "Deny" : "Audit"
  #     }
  #   })
  # }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_cost_center.id
    reference_id         = "requireCostCenter"
    parameter_values = jsonencode({
      defaultCostCenter = { value = var.tags["CostCenter"] }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_environment_tag.id
    reference_id         = "requireEnvironmentTag"
    parameter_values = jsonencode({
      defaultEnv = { value = var.environment }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_owner_tag.id
    reference_id         = "requireOwnerTag"
    parameter_values = jsonencode({
      defaultOwner = { value = var.tags["Owner"] }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowed_locations.id
    reference_id         = "allowedLocations"
    parameter_values = jsonencode({
      allowedLocations = { value = var.allowed_locations }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_storage.id
    reference_id         = "denyPublicStorage"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_https.id
    reference_id         = "enforceHttps"
  }

#   policy_definition_reference {
#     policy_definition_id = azurerm_policy_definition.deny_nic_public_ip.id
#     reference_id         = "denyNicPublicIp"
#   }

#   metadata = jsonencode({ category = "Governance" })
# }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_nic_public_ip.id
    reference_id = "denyNicPublicIp"
    parameter_values = jsonencode({
      effect = {
        value = var.environment == "prod"? "Deny" : "Audit"
      }
    })
  }
  metadata = jsonencode({ category = "Governance" })
}

########################################
# POLICY ASSIGNMENT
########################################
resource "azurerm_management_group_policy_assignment" "platform_gov" {
  name                 = "platform-gov"
  policy_definition_id = azurerm_management_group_policy_set_definition.platform_governance.id
  management_group_id  = azurerm_management_group.platform.id
  location             = var.location
  enforce              = true

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_management_group_policy_set_definition.platform_governance
  ]
}

########################################
# RBAC FOR POLICY IDENTITY
########################################
resource "azurerm_role_assignment" "policy_identity" {
  scope                = azurerm_management_group.platform.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.platform_gov.identity[0].principal_id
}

########################################
# REMEDIATION TASKS
########################################

resource "azurerm_management_group_policy_remediation" "remediate_costcenter" {
  name                           = "remediate-costcenter"
  management_group_id            = azurerm_management_group.platform.id
  policy_assignment_id           = azurerm_management_group_policy_assignment.platform_gov.id
  policy_definition_reference_id = "requireCostCenter"
  parallel_deployments           = 5
  failure_percentage             = 0.1

  depends_on = [azurerm_role_assignment.policy_identity]
}

resource "azurerm_management_group_policy_remediation" "remediate_environment" {
  name                           = "remediate-environment"
  management_group_id            = azurerm_management_group.platform.id
  policy_assignment_id           = azurerm_management_group_policy_assignment.platform_gov.id
  policy_definition_reference_id = "requireEnvironmentTag"
  parallel_deployments           = 5
  failure_percentage             = 0.1
  depends_on = [azurerm_role_assignment.policy_identity]
}

resource "azurerm_management_group_policy_remediation" "remediate_owner" {
  name                           = "remediate-owner"
  management_group_id            = azurerm_management_group.platform.id
  policy_assignment_id           = azurerm_management_group_policy_assignment.platform_gov.id
  policy_definition_reference_id = "requireOwnerTag"
  parallel_deployments           = 5
  failure_percentage             = 0.1

  depends_on = [azurerm_role_assignment.policy_identity]
}