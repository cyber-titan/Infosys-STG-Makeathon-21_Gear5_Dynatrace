resource "dynatrace_document" "otel_demo_payment_monitor" {
  name    = "[${var.environment}] Payment Monitor — otel-demo"
  type    = "dashboard"
  private = false

  content = jsonencode({
    version = 15
    tiles = {
      "0" = {
        type  = "data"
        title = "Payment Service — Request Volume"
        query = "fetch spans, from:now()-2h | filter service.name == \"payment\" | makeTimeseries count = count(), by:{service.name}"
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
        title = "Checkout Service — Request Volume"
        query = "fetch spans, from:now()-2h | filter service.name == \"checkout\" | makeTimeseries count = count(), by:{service.name}"
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
        title = "All Services — Error Spans"
        query = "fetch spans, from:now()-2h | filter status.code == \"2\" | makeTimeseries count = count(), by:{service.name}"
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
