
variable "subscription_id" {
  type    = string
  default = ""
}
variable "location" {
  type    = string
  default = ""
}
variable "rg_name" {
  type    = string
  default = ""
}
variable "db_server_name" {
  type    = string
  default = ""
}
variable "container_env" {
  type    = string
  default = ""
}
variable "container_apps" {
  type = list(object({
    name            = string
    image           = string
    tag             = string
    containerPort   = number
    ingress_enabled = bool
    min_replicas    = number
    max_replicas    = number
    cpu_requests    = number
    mem_requests    = string
  }))

  default = [{
    image           = "mcr.microsoft.com/azuredocs/containerapps-helloworld"
    tag             = "latest"
    name            = "conduitapi"
    containerPort   = 8000
    ingress_enabled = true
    min_replicas    = 1
    max_replicas    = 2
    cpu_requests    = 0.5
    mem_requests    = "1.0Gi"
    },
    {
      image           = "mcr.microsoft.com/azuredocs/containerapps-helloworld"
      tag             = "latest"
      name            = "conduitui"
      containerPort   = 3000
      ingress_enabled = true
      min_replicas    = 1
      max_replicas    = 2
      cpu_requests    = 0.5
      mem_requests    = "1.0Gi"
  }]

}