subnet_configs = [
  {
    name          = "prod-subnet-a"
    ip_cidr_range = "192.168.1.0/24"
    region        = "us-central1"
    private       = true
    secondary_ip_ranges = [
      {
        range_name    = "prod-pods-a"
        ip_cidr_range = "192.168.2.0/24"
      },
      {
        range_name    = "prod-services-a"
        ip_cidr_range = "192.168.3.0/24"
      }
    ]
  },
  {
    name          = "prod-subnet-b"
    ip_cidr_range = "192.168.4.0/24"
    region        = "us-east1"
    private       = true
    secondary_ip_ranges = [
      {
        range_name    = "prod-pods-b"
        ip_cidr_range = "192.168.5.0/24"
      },
      {
        range_name    = "prod-services-b"
        ip_cidr_range = "192.168.6.0/24"
      }
    ]
  }
]
