#################
# dataflow job
####################

resource "google_dataflow_job" "dataflow_job" {
  name                  = "dataflow-job"
  template_gcs_path     = "gs://dataflow-templates/latest/GCS_Text_to_BigQuery"
  service_account_email = google_service_account.sa.email
  temp_gcs_location     = "gs://${google_storage_bucket.bucket.id}/tmp_dir"
  network               = google_compute_network.network.name
  subnetwork            = "regions/${var.region}/subnetworks/${google_compute_subnetwork.data-subnet.name}"
  ip_configuration = "WORKER_IP_PRIVATE"
  parameters = {
    javascriptTextTransformGcsPath      = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.transform_js.name}"
    JSONPath                            = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.bqtable_schema_json.name}"
    javascriptTextTransformFunctionName = "transform"
    outputTable                         = "${var.project}:${google_bigquery_table.bqtable.dataset_id}.${google_bigquery_table.bqtable.table_id}"
    bigQueryLoadingTemporaryDirectory   = "${google_storage_bucket.bucket.url}/bq_tmp_dir"
    inputFilePattern                    = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.lorem_ipsum.name}"
  }
  on_delete = "cancel"
  depends_on = [
    google_project_iam_member.df_admin, google_project_iam_member.storage_admin
  ]
  machine_type = "n1-standard-4"
}

#################
# service account
####################

resource "google_service_account" "sa" {
  account_id = "dataflow-demo"
}

#################
# roles
####################

resource "google_project_iam_member" "df_worker" {
  project = var.project
  role   = "roles/dataflow.worker"
  member = "serviceAccount:${google_service_account.sa.email}"
  depends_on = [
  google_service_account.sa]
}

resource "google_project_iam_member" "df_admin" {
  project = var.project
  role   = "roles/dataflow.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
  depends_on = [
  google_service_account.sa
  ]
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "bq_admin" {
  project = var.project
  role   = "roles/bigquery.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}