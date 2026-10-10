resource "dynatrace_document" "otel_demo_payment_monitor" {
  name    = "[${var.environment}] Payment Monitor — otel-demo"
  type    = "dashboard"
  private = false

  content = jsonencode({
    version = 10
    tiles = {
      "0" = {
        type  = "data"
        title = "Payment Transactions"
        metricQuery = {
          metricSelector   = "demo.payment.transactions:splitBy(\"demo.payment.currency\"):sum"
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
      "1" = {
        type  = "data"
        title = "Payment Service — Error Rate"
        metricQuery = {
          metricSelector   = "builtin:service.errors.total.rate:filter(eq(dt.entity.service,SERVICE-payment)):avg"
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
      "2" = {
        type  = "data"
        title = "Checkout Service — Response Time"
        metricQuery = {
          metricSelector   = "builtin:service.response.time:filter(eq(dt.entity.service,SERVICE-checkout)):avg"
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
      "1" = { x = 8, y = 0, w = 8, h = 4 }
      "2" = { x = 0, y = 4, w = 8, h = 4 }
    }
  })
}
