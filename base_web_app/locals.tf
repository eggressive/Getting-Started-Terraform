##################################################################################
# LOCAL VARIABLES
##################################################################################

locals {
  common_tags = {
    company      = var.company_name
    project      = "${var.company_name}-${var.project_name}"
    billing_code = var.billing_code
    environment  = var.environment
  }

  s3_bucket_name = lower("${local.naming_prefix}-${random_integer.s3.result}")

  website_content = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }

  naming_prefix = "${var.naming_prefix}-${var.environment}"
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}