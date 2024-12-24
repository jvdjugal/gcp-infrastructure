subnet_configs = [
  {
    name          = "gke-subnet"
    ip_cidr_range = "10.0.0.0/16"
    region        = "us-central1"
    private       = true
    secondary_ip_ranges = [
      {
        range_name    = "gke-pods"
        ip_cidr_range = "10.2.0.0/20"
      },
      {
        range_name    = "gke-services"
        ip_cidr_range = "10.3.0.0/20"
      }
    ]
  },
  {
    name                = "sql-subnet"
    ip_cidr_range       = "10.1.0.0/16"
    region              = "us-central1"
    private             = true
    secondary_ip_ranges = []
  }
]
