variable "name" {
  description = "The name of the NodePool."
  type        = string
}

variable "labels" {
  description = "A map of labels to apply to the NodePool."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "A map of annotations to apply to the NodePool."
  type        = map(string)
  default     = {}
}

variable "disruption_budgets" {
  description = "Disruption budgets for the NodePool."
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
  description = "The duration after which to consolidate the NodePool."
  type        = string
  default     = "30s"
}

variable "disruption_consolidate_policy" {
  description = "The consolidation policy for the NodePool."
  type        = string
  default     = "WhenEmptyOrUnderutilized"
}

variable "expire_after" {
  description = "The duration after which the NodePool should expire."
  type        = string
  default     = "336h"
}

variable "node_class_name" {
  description = "The name of the NodeClass to reference."
  type        = string
  default     = "default"
}

variable "capacity_type" {
  description = "The capacity type for the NodePool."
  type        = list(string)
  default     = ["on-demand"]
}

variable "instance_categories" {
  description = "A list of instance categories to use for the NodePool."
  type        = list(string)
  default     = ["c", "m"]
}

variable "instance_cpus" {
  description = "A list of instance CPU counts to use for the NodePool."
  type        = list(string)
  default     = ["2", "4", "8", "16", "32"]
}

variable "instance_arch" {
  description = "A list of instance architectures to use for the NodePool."
  type        = list(string)
  default     = ["amd64"]
}

variable "instance_os" {
  description = "A list of instance operating systems to use for the NodePool."
  type        = list(string)
  default     = ["linux"]
}

variable "termination_grace_period" {
  description = "The termination grace period for the NodePool."
  type        = string
  default     = "24h0m0s"
}

variable "additional_requirements" {
  description = "Additional requirements for the NodePool."
  type = list(object({
    key      = string
    operator = string
    values   = list(string)
  }))
  default = []
}
