locals {
  df_base_uri               = "https://dataflow.googleapis.com/v1b3/projects/${var.project}/locations/${var.region}"
  url_encoded_template_path = urlencode("gs://dataflow-templates/latest/GCS_Text_to_BigQuery")
}