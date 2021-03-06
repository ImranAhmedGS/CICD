resource "google_bigquery_dataset" "dataset" {
        dataset_id                  = "gke_logs_dataset"
        friendly_name               = "sreboot"
        description                 = "Pushing logs to bigquery"

        lifecycle {
   	    prevent_destroy = false
  	}
        access {
            role          = "roles/bigquery.dataEditor"
            user_by_email = "sreboot@sreboot.iam.gserviceaccount.com"
        }

        access {
            role   = "READER"
            domain = "hashicorp.com"
        }
    }

resource "google_logging_project_sink" "bigquery-sink" {
  name        = "gke-bigquery-sinknew"
  destination = "bigquery.googleapis.com/projects/${var.project_name}/datasets/${google_bigquery_dataset.dataset.dataset_id}"
  filter      = "resource.type=k8s_container AND  resource.labels.project_id=sreboot AND  resource.labels.location=us-central1 AND  resource.labels.cluster_name=sreboot-gke AND  resource.labels.namespace_name=defaulti AND labels.k8s-pod/app=nginx AND log_name=projects/sreboot/logs/stderr "

}

resource "google_project_iam_member" "log_writer" {
    role = "roles/bigquery.dataEditor"
    member = google_logging_project_sink.bigquery-sink.writer_identity 
}

resource "google_bigquery_table" "logsink" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "stderr"
  lifecycle {
            prevent_destroy = false
        }


}


