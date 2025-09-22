locals {
  requirements = [
    {
      key      = "karpenter.sh/capacity-type"
      operator = "In"
      values   = var.capacity_type
    },
    {
      key      = "eks.amazonaws.com/instance-category"
      operator = "In"
      values   = var.instance_categories
    },
    {
      key      = "eks.amazonaws.com/instance-cpu"
      operator = "In"
      values   = var.instance_cpus
    },
    {
      key      = "eks.amazonaws.com/instance-generation"
      operator = "Gt"
      values   = ["4"]
    },
    {
      key      = "kubernetes.io/arch"
      operator = "In"
      values   = var.instance_arch
    },
    {
      key      = "kubernetes.io/os"
      operator = "In"
      values   = var.instance_os
    }
  ]
}

resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name        = var.name
      labels      = var.labels
      annotations = var.annotations
    }
    spec = {
      disruption = {
        budgets           = var.disruption_budgets
        consolidateAfter  = var.disruption_consolidate_after
        consolidationPolicy = var.disruption_consolidate_policy
      }

      template = {
        metadata = {
          labels      = var.labels
          annotations = var.annotations
        }

        spec = {
          expireAfter = var.expire_after

          nodeClassRef = {
            group = "eks.amazonaws.com"
            kind  = "NodeClass"
            name  = var.node_class_name
          }

          requirements = concat(local.requirements, var.additional_requirements)

          terminationGracePeriod = var.termination_grace_period
        }
      }
    }
  }
}
