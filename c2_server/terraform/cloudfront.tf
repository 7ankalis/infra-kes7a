resource "aws_cloudfront_distribution" "c2_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "C2 Fronting Distribution"
  price_class     = "PriceClass_100"

  origin {
    domain_name = aws_lb.c2_alb.dns_name
    origin_id   = "ALB-C2"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Custom-Header"
      value = var.cloudfront_secret_header
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-C2"

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
