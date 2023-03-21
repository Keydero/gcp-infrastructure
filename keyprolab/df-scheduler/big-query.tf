
resource "google_storage_bucket" "bucket" {
  name                        = "${var.project}-df-csv-to-bq"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "bqtable_schema_json" {

  name    = "bqtable-schema.json"
  content = "{\"BigQuery Schema\": ${file("${path.module}/code/bqtable-schema.json")}}"
  bucket  = google_storage_bucket.bucket.name

}

resource "google_storage_bucket_object" "transform_js" {
  name   = "transform.js"
  source = "${path.module}/code/transform.js"
  bucket = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "lorem_ipsum" {
  name   = "users.txt"
  source = "${path.module}/code/users.txt"
  bucket = google_storage_bucket.bucket.name
}

resource "google_bigquery_dataset" "bqdataset" {
  dataset_id = "dataflow_demo"
}

resource "google_bigquery_table" "bqtable" {
  dataset_id          = google_bigquery_dataset.bqdataset.dataset_id
  table_id            = "t"
  schema              = file("${path.module}/code/bqtable-schema.json")
  deletion_protection = false
}

