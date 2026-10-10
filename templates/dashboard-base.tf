# TEMPLATE: dashboard-base.tf
# AI uses this as structural reference when generating dashboards/<app>/<name>/main.tf
# Replace all <placeholders> with actual values when generating

resource "dynatrace_document" "<app_name>_<dashboard_name>" {
  name    = "[${var.environment}] <Human Readable Dashboard Name> — <app-name>"
  type    = "dashboard"
  private = false

  content = jsonencode({
    version = 10
    tiles = {
      "0" = {
        type  = "data"
        title = "<Metric Display Name>"
        metricQuery = {
          metricSelector   = "<metric.key>:splitBy():avg"
          resolution       = "auto"
          spaceAggregation = "AUTO"
        }
        visualizationSettings = {
          chartSettings = { gapPolicy = "connect" }
        }
        querySettings = {
          maxResultRecords       = 1000
          defaultScanLimitGbytes = 500
          maxResultMegaBytes     = 1
          defaultSamplingRatio   = 10
          enableSampling         = false
        }
      }
    }
    layouts = {
      "0" = { x = 0, y = 0, w = 8, h = 4 }
    }
  })
}
