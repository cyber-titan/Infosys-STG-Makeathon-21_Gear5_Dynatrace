# TEMPLATE: dashboard-base.tf
# AI uses this as structural reference when generating dashboards/<app>/<name>/main.tf
# Replace all <placeholders> with actual values when generating

resource "dynatrace_json_dashboard" "<app_name>_<dashboard_name>" {
  contents = jsonencode({
    dashboardMetadata = {
      name   = "<Human Readable Dashboard Name>"
      shared = false
      owner  = "ai-generator"
      tags   = ["generated", "<app-name>", "<dashboard-name>"]
    }

    tiles = [
      # --- HEADER TILE ---
      {
        name       = "<Section Title>"
        tileType   = "HEADER"
        configured = true
        bounds = {
          top    = 0
          left   = 0
          width  = 1482
          height = 38
        }
      },

      # --- METRIC CHART TILE ---
      {
        name       = "<Metric Display Name>"
        tileType   = "CUSTOM_CHARTING"
        configured = true
        bounds = {
          top    = 38
          left   = 0
          width  = 494
          height = 304
        }
        filterConfig = {
          type        = "MIXED"
          chartConfig = {
            type   = "TIMESERIES"
            series = [
              {
                metric      = "<metric.key>"
                aggregation = "AVG"
                type        = "LINE"
                entityType  = "SERVICE"
              }
            ]
          }
          filtersPerEntityType = {}
        }
      },

      # --- PROBLEMS TILE ---
      {
        name       = "Open Problems"
        tileType   = "OPEN_PROBLEMS"
        configured = true
        bounds = {
          top    = 38
          left   = 494
          width  = 494
          height = 304
        }
      },

      # --- SLO TILE (optional) ---
      {
        name       = "<SLO Name>"
        tileType   = "SLO"
        configured = true
        bounds = {
          top    = 38
          left   = 988
          width  = 494
          height = 304
        }
        assignedEntities = ["<slo-id>"]
      }
    ]
  })
}
