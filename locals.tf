locals {
  tags = merge(var.tags, {
    "firefly" = "true"
  })
}