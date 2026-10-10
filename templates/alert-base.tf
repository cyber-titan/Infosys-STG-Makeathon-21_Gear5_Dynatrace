# TEMPLATE: alert-base.tf
# AI uses this as structural reference when generating alerts/<app>/<name>/alerts.tf
# Replace all <placeholders> with actual values when generating

# --- METRIC-BASED ALERT ---
resource "dynatrace_metric_events" "<app_name>_<alert_name>" {
  enabled = true
  summary = "<Alert display name — shown in Dynatrace problems feed>"

  event_type     = "PERFORMANCE"   # options: PERFORMANCE, ERROR, AVAILABILITY, RESOURCE, CUSTOM_INFO
  event_template {
    title       = "<Problem title shown to on-call team>"
    description = "<What this alert means and what to check first>"
    davis_merge = true
  }

  metric_selector = "<metric.key>:splitBy():avg:auto:sort(value(avg,descending)):limit(10)"

  model_properties {
    type               = "STATIC_THRESHOLD"
    threshold          = <numeric_threshold>      # e.g. 0.05 for 5% error rate
    alert_condition    = "ABOVE"                  # ABOVE or BELOW
    alert_on_no_data   = false
    dealerting_samples = 5
    samples            = 5
    violating_samples  = 3
  }
}

# --- ALERTING PROFILE (routes alerts to notification channels) ---
resource "dynatrace_alerting" "<app_name>_alerting_profile" {
  name = "<App Name> — <Dashboard Name> Alerts"

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
