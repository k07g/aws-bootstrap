resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = var.comment

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}
