resource "dynatrace_alerting" "otel_demo_payment_alerting_profile" {
  name = "[${var.environment}] otel-demo Payment Alerts"

  rules {
    rule {
      include_mode     = "INCLUDE_ALL"
      delay_in_minutes = 0
      severity_level   = "PERFORMANCE"
      tag_filter {
        include_mode = "INCLUDE_ALL"
      }
    }
    rule {
      include_mode     = "INCLUDE_ALL"
      delay_in_minutes = 0
      severity_level   = "ERROR"
      tag_filter {
        include_mode = "INCLUDE_ALL"
      }
    }
  }
}
