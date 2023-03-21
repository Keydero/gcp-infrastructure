# TODO docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint


module "df-scheduler" {
  source  = "./df-scheduler"
  project = var.project
  region  = "europe-west1" #icp
}



