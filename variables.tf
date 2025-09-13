variable "name" {
  description = "The name of the Karpenter NodePool resource. This will be used as the metadata.name in the Kubernetes manifest."
  type        = string
}

variable "labels" {
  description = "A map of Kubernetes labels to apply to both the NodePool metadata and the node template. These labels help identify and categorize nodes."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "A map of Kubernetes annotations to apply to both the NodePool metadata and the node template. Annotations provide additional metadata without affecting node selection."
  type        = map(string)
  default     = {}
}

variable "disruption_budgets" {
  description = "Disruption budgets that limit the number of nodes that can be disrupted simultaneously. Helps prevent service disruption during node replacements."
  type = list(object({
    nodes = string
  }))
  default = [
    {
      nodes = "10%"
    }
  ]
}

variable "disruption_consolidate_after" {
  description = "The duration after which Karpenter will consider consolidating nodes. Nodes must be empty or underutilized for this duration before consolidation."
  type        = string
  default     = "30s"
}

variable "disruption_consolidate_policy" {
  description = "The consolidation policy that determines when Karpenter can consolidate nodes. Options: WhenEmptyOrUnderutilized, WhenEmpty, WhenUnderutilized."
  type        = string
  default     = "WhenEmptyOrUnderutilized"
}

variable "expire_after" {
  description = "The duration after which nodes provisioned by this NodePool will be automatically terminated. Helps ensure nodes are refreshed regularly (default: 14 days)."
  type        = string
  default     = "336h"
}

variable "node_class_name" {
  description = "The name of the Karpenter NodeClass resource that defines the EC2 instance configuration (subnets, security groups, AMI, etc.) for nodes in this pool."
  type        = string
  default     = "default"
}

variable "capacity_type" {
  description = "The EC2 capacity types that nodes in this pool can use. Options: on-demand, spot. Spot instances provide cost savings but can be interrupted."
  type        = list(string)
  default     = ["on-demand"]
}

variable "instance_categories" {
  description = "EC2 instance family categories that nodes in this pool can use. Common options: c (compute-optimized), m (general-purpose), r (memory-optimized), g (GPU), i (storage-optimized)."
  type        = list(string)
  default     = ["c", "m"]
}

variable "instance_cpus" {
  description = "The number of vCPUs that nodes in this pool can have. Karpenter will select instances with these CPU counts from the specified instance categories."
  type        = list(string)
  default     = ["2", "4", "8", "16", "32"]
}

variable "instance_arch" {
  description = "The CPU architectures that nodes in this pool can use. Options: amd64 (x86_64), arm64 (ARM64). Must match your workload requirements."
  type        = list(string)
  default     = ["amd64"]
}

variable "instance_os" {
  description = "The operating systems that nodes in this pool can run. Options: linux, windows. Most EKS workloads use linux."
  type        = list(string)
  default     = ["linux"]
}

variable "termination_grace_period" {
  description = "The duration Karpenter will wait before forcefully terminating a node that is not draining properly. Helps ensure graceful pod eviction."
  type        = string
  default     = "24h0m0s"
}

variable "additional_requirements" {
  description = "Additional node selector requirements beyond the default ones. Allows fine-grained control over node selection using Kubernetes node selectors (e.g., instance types, zones, custom labels)."
  type = list(object({
    key      = string
    operator = string
    values   = list(string)
  }))
  default = []
}
