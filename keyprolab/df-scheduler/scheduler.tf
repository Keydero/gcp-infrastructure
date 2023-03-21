resource "google_cloud_scheduler_job" "trigger_dataflow_job_via_api" {
  name      = "schedule-dataflow-job"
  schedule  = "* * * * *"
  time_zone = "Europe/Paris"
  http_target {
    http_method = "POST"
    uri         = "${local.df_base_uri}/templates:launch?gcsPath=${local.url_encoded_template_path}"

    headers = {
      "Content-Type" = "application/json"
    }
    body = base64encode(
      jsonencode(
        {
          jobName = "dataflow-job-from-scheduler"
          parameters = {
            javascriptTextTransformGcsPath      = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.transform_js.name}"
            JSONPath                            = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.bqtable_schema_json.name}"
            javascriptTextTransformFunctionName = "transform"
            outputTable                         = "${var.project}:${google_bigquery_table.bqtable.dataset_id}.${google_bigquery_table.bqtable.table_id}"
            bigQueryLoadingTemporaryDirectory   = "${google_storage_bucket.bucket.url}/bq_tmp_dir"
            inputFilePattern                    = "${google_storage_bucket.bucket.url}/${google_storage_bucket_object.lorem_ipsum.name}"
          }
          environment = {
            tempLocation        = "gs://${google_storage_bucket.bucket.id}/tmp_dir"
            network             = google_compute_network.network.name
            serviceAccountEmail = google_service_account.sa.email
          }
        }
      )
    )
    oauth_token {
      service_account_email = google_service_account.sa.email
    }
  }
}

#######################################
# terraform, me the deployer
#
resource "google_service_account_iam_member" "act_as_the_deployer" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.sa.email}"
}
