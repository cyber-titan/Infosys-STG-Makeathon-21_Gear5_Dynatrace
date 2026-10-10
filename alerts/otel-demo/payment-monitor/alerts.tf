resource "dynatrace_metric_events" "otel_demo_payment_error_rate" {
  enabled = true
  summary = "[${var.environment}] Payment Service — High Error Rate"

  event_type = "PERFORMANCE"

  event_template {
    title       = "Payment error rate exceeds threshold"
    description = "The payment service error rate has exceeded 10%. Check payment provider connectivity and card validation logic."
    davis_merge = true
  }

  metric_selector = "builtin:service.errors.total.rate:filter(eq(dt.entity.service,SERVICE-payment)):splitBy():avg:auto:sort(value(avg,descending)):limit(10)"

  model_properties {
    type               = "STATIC_THRESHOLD"
    threshold          = 10
    alert_condition    = "ABOVE"
    alert_on_no_data   = false
    dealerting_samples = 5
    samples            = 5
    violating_samples  = 3
  }
}

resource "dynatrace_alerting" "otel_demo_payment_alerting_profile" {
  name = "[${var.environment}] otel-demo Payment Alerts"

  rules {
    rule {
      include_mode     = "INCLUDE_ALL"
      delay_in_minutes = 0
      severity_level   = "PERFORMANCE"
    }
    rule {
      include_mode     = "INCLUDE_ALL"
      delay_in_minutes = 0
      severity_level   = "ERROR"
    }
  }
}
