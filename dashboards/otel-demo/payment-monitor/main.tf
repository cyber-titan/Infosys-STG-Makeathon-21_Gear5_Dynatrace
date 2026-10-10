resource "dynatrace_json_dashboard" "otel_demo_payment_monitor" {
  contents = jsonencode({
    dashboardMetadata = {
      name   = "[${var.environment}] Payment Monitor — otel-demo"
      shared = false
      owner  = "ai-generator"
      tags   = ["generated", "otel-demo", "payment-monitor"]
    }
    tiles = [
      {
        name       = "Payment Overview"
        tileType   = "HEADER"
        configured = true
        bounds     = { top = 0, left = 0, width = 1482, height = 38 }
      },
      {
        name       = "Payment Transactions"
        tileType   = "DATA_EXPLORER"
        configured = true
        bounds     = { top = 38, left = 0, width = 494, height = 304 }
        customName = "Payment Transactions"
        queries = [
          {
            id         = "A"
            metric     = "demo.payment.transactions"
            spaceAggregation = "SUM"
            timeAggregation  = "DEFAULT"
            splitBy    = ["demo.payment.currency"]
            enabled    = true
          }
        ]
        visualConfig = {
          type = "GRAPH_CHART"
          rules = [{ matcher = "A", unitTransform = "Count" }]
        }
      },
      {
        name       = "Open Problems"
        tileType   = "OPEN_PROBLEMS"
        configured = true
        bounds     = { top = 38, left = 494, width = 494, height = 304 }
      },
      {
        name       = "Checkout Service — Request Rate"
        tileType   = "DATA_EXPLORER"
        configured = true
        bounds     = { top = 38, left = 988, width = 494, height = 304 }
        customName = "Checkout Request Rate"
        queries = [
          {
            id         = "A"
            metric     = "builtin:service.requestCount.total"
            spaceAggregation = "SUM"
            timeAggregation  = "DEFAULT"
            filterBy   = { dimensionFilter = [{ filterType = "DIMENSION", key = "dt.entity.service", value = "SERVICE-checkout" }] }
            enabled    = true
          }
        ]
        visualConfig = {
          type = "GRAPH_CHART"
          rules = [{ matcher = "A", unitTransform = "Count/min" }]
        }
      },
      {
        name       = "Payment Service — Error Rate"
        tileType   = "DATA_EXPLORER"
        configured = true
        bounds     = { top = 342, left = 0, width = 494, height = 304 }
        customName = "Payment Error Rate"
        queries = [
          {
            id         = "A"
            metric     = "builtin:service.errors.total.rate"
            spaceAggregation = "AVG"
            timeAggregation  = "DEFAULT"
            filterBy   = { dimensionFilter = [{ filterType = "DIMENSION", key = "dt.entity.service", value = "SERVICE-payment" }] }
            enabled    = true
          }
        ]
        visualConfig = {
          type = "GRAPH_CHART"
          rules = [{ matcher = "A", unitTransform = "Percent" }]
        }
      },
      {
        name       = "Checkout Service — Response Time"
        tileType   = "DATA_EXPLORER"
        configured = true
        bounds     = { top = 342, left = 494, width = 494, height = 304 }
        customName = "Checkout Response Time"
        queries = [
          {
            id         = "A"
            metric     = "builtin:service.response.time"
            spaceAggregation = "AVG"
            timeAggregation  = "DEFAULT"
            filterBy   = { dimensionFilter = [{ filterType = "DIMENSION", key = "dt.entity.service", value = "SERVICE-checkout" }] }
            enabled    = true
          }
        ]
        visualConfig = {
          type = "GRAPH_CHART"
          rules = [{ matcher = "A", unitTransform = "MilliSecond" }]
        }
      }
    ]
  })
}
