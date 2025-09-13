# AWS EKS Node Pool Terraform Module

A Terraform module that creates a Karpenter NodePool resource for Amazon EKS clusters using auto-mode. This module simplifies the creation and management of Karpenter NodePools with sensible defaults and flexible configuration options.

## Features

- **Karpenter NodePool Management**: Creates and manages Karpenter NodePool resources
- **Flexible Instance Selection**: Configurable capacity types, instance categories, CPU counts, architectures, and operating systems
- **Disruption Management**: Built-in disruption budgets and consolidation policies
- **Customizable Requirements**: Support for additional node requirements beyond the defaults
- **Label and Annotation Support**: Full support for Kubernetes labels and annotations
- **Node Expiration**: Configurable node expiration policies

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| kubernetes | ~> 2.38.0 |

## Usage

### Basic Usage

```hcl
module "eks_nodepool" {
  source = "path/to/terraform-aws-eks-nodepool"

  name            = "my-nodepool"
  node_class_name = "default"
}
```

### Advanced Usage

```hcl
module "eks_nodepool" {
  source = "path/to/terraform-aws-eks-nodepool"

  name            = "production-nodepool"
  node_class_name = "production-nodeclass"

  # Instance configuration
  capacity_type        = ["spot", "on-demand"]
  instance_categories  = ["c", "m", "r"]
  instance_cpus       = ["4", "8", "16"]
  instance_arch       = ["amd64"]
  instance_os         = ["linux"]

  # Disruption settings
  disruption_budgets = [
    {
      nodes = "20%"
    }
  ]
  disruption_consolidate_after  = "60s"
  disruption_consolidate_policy = "WhenEmptyOrUnderutilized"

  # Node lifecycle
  expire_after                = "168h"  # 7 days
  termination_grace_period    = "12h0m0s"

  # Labels and annotations
  labels = {
    environment = "production"
    team        = "platform"
  }

  annotations = {
    "karpenter.sh/description" = "Production workload nodepool"
  }

  # Additional requirements
  additional_requirements = [
    {
      key      = "node.kubernetes.io/instance-type"
      operator = "In"
      values   = ["m5.large", "m5.xlarge", "c5.large"]
    }
  ]
}
```

## Resources

| Name | Type |
|------|------|
| kubernetes_manifest.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the NodePool | `string` | n/a | yes |
| labels | A map of labels to apply to the NodePool | `map(string)` | `{}` | no |
| annotations | A map of annotations to apply to the NodePool | `map(string)` | `{}` | no |
| disruption_budgets | Disruption budgets for the NodePool | `list(object({nodes = string}))` | `[{nodes = "10%"}]` | no |
| disruption_consolidate_after | The duration after which to consolidate the NodePool | `string` | `"30s"` | no |
| disruption_consolidate_policy | The consolidation policy for the NodePool | `string` | `"WhenEmptyOrUnderutilized"` | no |
| expire_after | The duration after which the NodePool should expire | `string` | `"336h"` | no |
| node_class_name | The name of the NodeClass to reference | `string` | `"default"` | no |
| capacity_type | The capacity type for the NodePool | `list(string)` | `["on-demand"]` | no |
| instance_categories | A list of instance categories to use for the NodePool | `list(string)` | `["c", "m"]` | no |
| instance_cpus | A list of instance CPU counts to use for the NodePool | `list(string)` | `["2", "4", "8", "16", "32"]` | no |
| instance_arch | A list of instance architectures to use for the NodePool | `list(string)` | `["amd64"]` | no |
| instance_os | A list of instance operating systems to use for the NodePool | `list(string)` | `["linux"]` | no |
| termination_grace_period | The termination grace period for the NodePool | `string` | `"24h0m0s"` | no |
| additional_requirements | Additional requirements for the NodePool | `list(object({key = string, operator = string, values = list(string)}))` | `[]` | no |

## Outputs

This module does not currently define any outputs.

## Default Requirements

The module automatically includes the following node requirements:

- **Capacity Type**: Configurable via `capacity_type` variable (default: on-demand)
- **Instance Category**: Configurable via `instance_categories` variable (default: c, m)
- **Instance CPU**: Configurable via `instance_cpus` variable (default: 2, 4, 8, 16, 32)
- **Instance Generation**: Fixed to generation 4 and above
- **Architecture**: Configurable via `instance_arch` variable (default: amd64)
- **Operating System**: Configurable via `instance_os` variable (default: linux)

## Examples

### Spot Instance NodePool

```hcl
module "spot_nodepool" {
  source = "path/to/terraform-aws-eks-nodepool"

  name            = "spot-nodepool"
  capacity_type   = ["spot"]
  instance_cpus   = ["2", "4", "8"]
  expire_after    = "24h"
}
```

### GPU NodePool

```hcl
module "gpu_nodepool" {
  source = "path/to/terraform-aws-eks-nodepool"

  name            = "gpu-nodepool"
  instance_categories = ["g"]
  instance_cpus  = ["8", "16", "32"]
  
  additional_requirements = [
    {
      key      = "node.kubernetes.io/instance-type"
      operator = "In"
      values   = ["g4dn.xlarge", "g4dn.2xlarge", "g4dn.4xlarge"]
    }
  ]
}
```

## License

This module is released under the MIT License.