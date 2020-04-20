resource "kubernetes_secret" "credential_secret" {
  count = length(keys(var.databases))
  metadata {
    name      = "cloudsql-${element(keys(var.databases), count.index)}"
    namespace = var.credential_secret_namespace
  }

  data = {
    instance = google_sql_database_instance.instance.connection_name
    database = google_sql_database.database[count.index].name
    username = google_sql_user.database_user[count.index].name
    password = google_sql_user.database_user[count.index].password
  }

  depends_on = [
    google_sql_database.database,
    google_sql_user.database_user,
  ]
}
