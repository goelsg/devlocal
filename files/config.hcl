ui = true

log_level = "trace"

storage "file" {
  path = "/mnt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8443"
  tls_disable = 1
}

disable_mlock = true

api_addr = "http://127.0.0.1:8443"

cluster_addr = "https://127.0.0.1:8444"