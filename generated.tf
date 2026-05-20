resource "random_password" "jwt_secret" {
  length  = 64
  special = false
}

resource "jwt_hashed_token" "anon" {
  secret    = random_password.jwt_secret.result
  algorithm = "HS256"

  claims_json = jsonencode({
    role = "anon"
    iss  = "supabase"
    iat  = 1641769200
    exp  = 1799535600
  })
}

resource "jwt_hashed_token" "service" {
  secret    = random_password.jwt_secret.result
  algorithm = "HS256"

  claims_json = jsonencode({
    role = "service_role"
    iss  = "supabase"
    iat  = 1641769200
    exp  = 1799535600
  })
}
