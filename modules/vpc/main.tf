resource "google_compute_network" "vpc" {
  for_each                = var.vpcs
  name                    = each.key
  auto_create_subnetworks = each.value.auto_create_subnetworks
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc[var.vpc_name].id # Changed from hardcoded "my-vpc"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name] # Changed to reference the actual resource
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.vpc_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc[var.vpc_name].id # Changed from hardcoded "my-vpc"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.vpc_name}-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc[var.vpc_name].id # Changed from hardcoded "my-vpc"
  project       = var.project_id
}

resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for subnet in local.all_subnets : "${subnet.vpc_name}-${subnet.subnet.name}" => subnet }
  name                     = each.value.subnet.name
  ip_cidr_range            = each.value.subnet.ip_cidr_range
  region                   = each.value.subnet.region
  network                  = google_compute_network.vpc[each.value.vpc_name].id
  private_ip_google_access = each.value.subnet.private

  dynamic "secondary_ip_range" {
    for_each = each.value.subnet.secondary_ip_ranges
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
}

resource "google_compute_firewall" "rules" {
  for_each = { for rule in local.all_firewall_rules : "${rule.vpc_name}-${rule.rule.name}" => rule }

  name    = each.value.rule.name
  network = google_compute_network.vpc[each.value.vpc_name].name

  allow {
    protocol = each.value.rule.protocol
    ports    = each.value.rule.ports
  }

  source_ranges = each.value.rule.source_ranges
}

resource "google_compute_router" "router" {
  for_each = { for name, vpc in var.vpcs : name => vpc if vpc.create_nat }

  name    = "${each.key}-router"
  region  = var.region
  network = google_compute_network.vpc[each.key].id
}

resource "google_compute_router_nat" "nat" {
  for_each = { for name, vpc in var.vpcs : name => vpc if vpc.create_nat }

  name                               = "${each.key}-nat"
  router                             = google_compute_router.router[each.key].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

locals {
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
}
