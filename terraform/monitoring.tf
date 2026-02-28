resource "aws_cloudwatch_log_group" "app" {
  name = "/aws/${var.project_name}"
}