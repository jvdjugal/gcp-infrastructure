# VPC Module main configuration
locals {
  resource_prefix = "${var.project_id}-${var.environment}"

  # Flatten subnet and firewall configurations for easier management
  all_subnets = flatten([
    for vpc_name, vpc in var.vpcs : [
      for subnet in vpc.subnets : {
        vpc_name = vpc_name
        subnet   = subnet
      }
    ]
  ])

  all_firewall_rules = flatten([
    for vpc_name, vpc in var.vpcs : [
      for rule in vpc.firewall_rules : {
        vpc_name = vpc_name
        rule     = rule
      }
    ]
  ])

  common_labels = {
    environment = var.environment
    managed_by  = "terraform"
    project     = var.project_id
  }
}

# VPC Networks
resource "google_compute_network" "vpc" {
  for_each                = var.vpcs
  name                    = "${local.resource_prefix}-${each.key}"
  auto_create_subnetworks = each.value.auto_create_subnetworks
  project                 = var.project_id

  lifecycle {
    create_before_destroy = true
  }
}

# Global IP Address for VPC Peering
resource "google_compute_global_address" "private_ip_addresses" {
  for_each      = toset(["primary", "secondary"])
  name          = "${local.resource_prefix}-${var.vpc_name}-private-ip-${each.key}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc["my-vpc"].id
  project       = var.project_id


}

# Service Networking Connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc["my-vpc"].id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_addresses["primary"].name]

  timeouts {
    create = "30m"
    update = "40m"
    delete = "30m"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    google_compute_network.vpc,
    google_compute_global_address.private_ip_addresses
  ]
}

# Service Account

# Subnets
resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for subnet in local.all_subnets : "${subnet.vpc_name}-${subnet.subnet.name}" => subnet }
  name                     = "${local.resource_prefix}-${each.value.subnet.name}"
  ip_cidr_range            = each.value.subnet.ip_cidr_range
  region                   = each.value.subnet.region
  network                  = google_compute_network.vpc[each.value.vpc_name].id
  private_ip_google_access = each.value.subnet.private
  project                  = var.project_id

  dynamic "secondary_ip_range" {
    for_each = each.value.subnet.secondary_ip_ranges != null ? each.value.subnet.secondary_ip_ranges : []
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Firewall Rules
resource "google_compute_firewall" "rules" {
  for_each = { for rule in local.all_firewall_rules : "${rule.vpc_name}-${rule.rule.name}" => rule }

  name        = "${local.resource_prefix}-${each.value.rule.name}"
  network     = google_compute_network.vpc[each.value.vpc_name].name
  project     = var.project_id
  description = "Managed by Terraform"

  allow {
    protocol = each.value.rule.protocol
    ports    = each.value.rule.ports
  }

  source_ranges = each.value.rule.source_ranges
  target_tags   = try(each.value.rule.target_tags, null)

  lifecycle {
    create_before_destroy = true
  }
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  for_each = { for name, vpc in var.vpcs : name => vpc if vpc.create_nat }

  name    = "${local.resource_prefix}-${each.key}-router"
  region  = var.region
  network = google_compute_network.vpc[each.key].id
  project = var.project_id

  lifecycle {
    create_before_destroy = true
  }
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  for_each = { for name, vpc in var.vpcs : name => vpc if vpc.create_nat }

  name                               = "${local.resource_prefix}-${each.key}-nat"
  router                             = google_compute_router.router[each.key].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  lifecycle {
    create_before_destroy = true
  }
}
