resource "ovh_cloud_project_storage" "storage" {
  service_name = var.ovh_service_name
  region_name  = "WAW"
  name         = "krywlo-supabase-storage"
}

resource "ovh_cloud_project_user" "user" {
  service_name = var.ovh_service_name
  description  = "user for supabase storage access"
}

resource "ovh_cloud_project_user_s3_credential" "s3_credential" {
  service_name = var.ovh_service_name
  user_id      = ovh_cloud_project_user.user.id
}

resource "ovh_cloud_project_user_s3_policy" "s3_policy" {
  service_name = var.ovh_service_name
  user_id      = ovh_cloud_project_user.user.id
  policy = jsonencode({
    "Statement" : [{
      "Sid" : "RWContainer",
      "Effect" : "Allow",
      "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListMultipartUploadParts", "s3:ListBucketMultipartUploads", "s3:AbortMultipartUpload", "s3:GetBucketLocation"],
      "Resource" : ["arn:aws:s3:::${ovh_cloud_project_storage.storage.name}", "arn:aws:s3:::${ovh_cloud_project_storage.storage.name}/*"]
    }]
  })
}
