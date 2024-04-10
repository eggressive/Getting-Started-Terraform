##################################################################################
# LOCAL VARIABLES
##################################################################################

locals {
  common_tags = {
    company      = var.company_name
    project      = "${var.company_name}-${var.project_name}"
    billing_code = var.billing_code
  }

  s3_bucket_name = "globo-web-app-${random_integer.s3.result}"

  website_content = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}